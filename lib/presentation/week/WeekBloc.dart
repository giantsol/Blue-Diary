
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/HomeChildScreenItem.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/AddSeedUsecase.dart';
import 'package:todo_app/domain/usecase/GetCompletedMarkableDayToKeepStreakUsecase.dart';
import 'package:todo_app/domain/usecase/GetStreakCountUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/domain/usecase/GetWeekRecordUsecase.dart';
import 'package:todo_app/domain/usecase/HasShownWeekScreenTutorialUsecase.dart';
import 'package:todo_app/domain/usecase/SetCheckPointUsecase.dart';
import 'package:todo_app/domain/usecase/SetDayMarkedCompletedUsecase.dart';
import 'package:todo_app/domain/usecase/SetRealFirstLaunchDateIfNotExistsUsecase.dart';
import 'package:todo_app/domain/usecase/SetShownFirstCompletableDayTutorialUsecase.dart';
import 'package:todo_app/domain/usecase/SetShownWeekScreenTutorialUsecase.dart';
import 'package:todo_app/presentation/day/DayScreen.dart';
import 'package:todo_app/presentation/week/FirstCompletableDayTutorial.dart';
import 'package:todo_app/presentation/week/WeekScreenTutorial.dart';
import 'package:todo_app/presentation/week/WeekScreenTutorialCallback.dart';
import 'package:todo_app/presentation/week/WeekState.dart';

class WeekBloc {
  static const _sevenDays = const Duration(days: 7);

  final _state = BehaviorSubject<WeekState>.seeded(WeekState());
  WeekState getInitialState() => _state.value;
  Stream<WeekState> observeState() => _state.distinct();

  final GetTodayUsecase _getTodayUsecase;
  final GetWeekRecordUsecase _getWeekRecordUsecase;
  final SetRealFirstLaunchDateIfNotExistsUsecase _setRealFirstLaunchDateIfNotExistsUsecase;
  final HasShownWeekScreenTutorialUsecase _hasShownWeekScreenTutorialUsecase;
  final SetCheckPointUsecase _setCheckPointUsecase;
  final SetShownWeekScreenTutorialUsecase _setShownWeekScreenTutorialUsecase;
  final GetCompletedMarkableDayToKeepStreakUsecase _getCompletedMarkableDayToKeepStreakUsecase;
  final SetDayMarkedCompletedUsecase _setDayMarkedCompletedUsecase;
  final GetStreakCountUsecase _getStreakCountUsecase;
  final AddSeedUsecase _addSeedUsecase;
  final SetShownFirstCompletableDayTutorialUsecase _setShownFirstCompletableDayTutorialUsecase;

  WeekBlocDelegator delegator;

  WeekBloc(DateRepository dateRepository, PrefsRepository prefsRepository, ToDoRepository toDoRepository, MemoRepository memoRepository, {
    @required this.delegator
  }): _getTodayUsecase = GetTodayUsecase(dateRepository),
      _getWeekRecordUsecase = GetWeekRecordUsecase(prefsRepository, toDoRepository, memoRepository, dateRepository),
      _setRealFirstLaunchDateIfNotExistsUsecase = SetRealFirstLaunchDateIfNotExistsUsecase(prefsRepository),
      _hasShownWeekScreenTutorialUsecase = HasShownWeekScreenTutorialUsecase(prefsRepository),
      _setCheckPointUsecase = SetCheckPointUsecase(memoRepository),
      _setShownWeekScreenTutorialUsecase = SetShownWeekScreenTutorialUsecase(prefsRepository),
      _getCompletedMarkableDayToKeepStreakUsecase = GetCompletedMarkableDayToKeepStreakUsecase(toDoRepository, prefsRepository, dateRepository),
      _setDayMarkedCompletedUsecase = SetDayMarkedCompletedUsecase(toDoRepository),
      _getStreakCountUsecase = GetStreakCountUsecase(toDoRepository),
      _addSeedUsecase = AddSeedUsecase(prefsRepository),
      _setShownFirstCompletableDayTutorialUsecase = SetShownFirstCompletableDayTutorialUsecase(prefsRepository)
  {
    _initState();
    delegator.addBottomNavigationItemClickedListener(_bottomNavigationItemClickedListener);
  }

  void _bottomNavigationItemClickedListener(String key) {
    if (key == HomeChildScreenItem.KEY_RECORD) {
      _state.add(_state.value.buildNew(
        moveToTodayEvent: true,
        scrollToTodayPreviewEvent: true,
      ));
    }
  }

  Future<void> _initState() async {
    final initialDate = await _getTodayUsecase.invoke();
    if (initialDate == DateRepository.INVALID_DATE) {
      _state.add(_state.value.buildNew(
        viewState: WeekViewState.NETWORK_ERROR,
      ));
    } else {
      _setRealFirstLaunchDateIfNotExistsUsecase.invoke(initialDate);

      final dateInWeek = DateInWeek.fromDate(initialDate);
      final currentWeekRecord = await _getWeekRecordUsecase.invoke(initialDate);
      final prevWeekRecord = await _getWeekRecordUsecase.invoke(initialDate.subtract(_sevenDays));
      final nextWeekRecord = await _getWeekRecordUsecase.invoke(initialDate.add(_sevenDays));
      final startTutorial = !(await _hasShownWeekScreenTutorialUsecase.invoke());
      final showFirstCompletableDayTutorial = currentWeekRecord.firstCompletableDayTutorialIndex >= 0;

      _state.add(_state.value.buildNew(
        viewState: WeekViewState.NORMAL,
        year: dateInWeek.year,
        month: dateInWeek.month,
        nthWeek: dateInWeek.nthWeek,
        currentWeekRecord: currentWeekRecord,
        prevWeekRecord: prevWeekRecord,
        nextWeekRecord: nextWeekRecord,
        initialDate: initialDate,
        currentWeekRecordPageIndex: _state.value.initialWeekRecordPageIndex,
        currentDate: initialDate,
        pageViewScrollEnabled: !startTutorial && !showFirstCompletableDayTutorial,

        startTutorialEvent: startTutorial,
        scrollToTodayPreviewEvent: !startTutorial,
        showFirstCompletableDayTutorialEvent: showFirstCompletableDayTutorial,
      ));
    }
  }

  void updateDelegator(WeekBlocDelegator delegator) {
    this.delegator.removeBottomNavigationItemClickedListener(_bottomNavigationItemClickedListener);
    this.delegator = delegator;
    this.delegator.addBottomNavigationItemClickedListener(_bottomNavigationItemClickedListener);
  }

  Future<void> onWeekRecordPageIndexChanged(int newIndex) async {
    final currentDate = _state.value.initialDate.add(Duration(days: 7 * (newIndex - _state.value.initialWeekRecordPageIndex)));
    final dateInWeek = DateInWeek.fromDate(currentDate);

    // update date text first for smoother UI
    _state.add(_state.value.buildNew(
      year: dateInWeek.year,
      month: dateInWeek.month,
      nthWeek: dateInWeek.nthWeek,
      currentWeekRecordPageIndex: newIndex,
      currentDate: currentDate,
    ));

    final currentWeekRecord = await _getWeekRecordUsecase.invoke(currentDate);
    final prevWeekRecord = await _getWeekRecordUsecase.invoke(currentDate.subtract(_sevenDays));
    final nextWeekRecord = await _getWeekRecordUsecase.invoke(currentDate.add(_sevenDays));
    final showFirstCompletableDayTutorialEvent = currentWeekRecord.firstCompletableDayTutorialIndex >= 0;

    _state.add(_state.value.buildNew(
      currentWeekRecord: currentWeekRecord,
      prevWeekRecord: prevWeekRecord,
      nextWeekRecord: nextWeekRecord,
      pageViewScrollEnabled: !showFirstCompletableDayTutorialEvent,

      showFirstCompletableDayTutorialEvent: showFirstCompletableDayTutorialEvent,
    ));
  }

  void onCheckPointTextChanged(CheckPoint checkPoint, String changed) {
    final updatedCheckPoint = checkPoint.buildNew(text: changed);
    _state.add(_state.value.buildNewCheckPointUpdated(updatedCheckPoint));
    _setCheckPointUsecase.invoke(checkPoint);
  }

  Future<void> onDayPreviewClicked(BuildContext context, DayPreview dayPreview) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayScreen(dayPreview.date),
      ),
    );

    final currentWeekRecord = await _getWeekRecordUsecase.invoke(_state.value.currentDate);
    final showFirstCompletableDayTutorialEvent = currentWeekRecord.firstCompletableDayTutorialIndex >= 0;

    _state.add(_state.value.buildNew(
      currentWeekRecord: currentWeekRecord,
      pageViewScrollEnabled: !showFirstCompletableDayTutorialEvent,

      showFirstCompletableDayTutorialEvent: showFirstCompletableDayTutorialEvent,
    ));
  }

  void onNextArrowClicked() {
    final newPageIndex = _state.value.currentWeekRecordPageIndex + 1;
    _state.add(_state.value.buildNew(
      currentWeekRecordPageIndex: newPageIndex,
      animateToPageEvent: newPageIndex,
    ));
  }

  Future<void> onPrevArrowClicked() async {
    final newPageIndex = _state.value.currentWeekRecordPageIndex - 1;
    _state.add(_state.value.buildNew(
      currentWeekRecordPageIndex: newPageIndex,
      animateToPageEvent: newPageIndex,
    ));
  }

  Future<void> startTutorial(BuildContext context, WeekScreenTutorialCallback callback) async {
    // just rebuild to clear startTutorialEvent flag
    _state.add(_state.value.buildNew());

    await Navigator.push(context, PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => WeekScreenTutorial(
        weekScreenTutorialCallback: callback,
      ),
    ));

    _setShownWeekScreenTutorialUsecase.invoke();

    _state.add(_state.value.buildNew(
      pageViewScrollEnabled: true,
    ));
  }

  void onNetworkErrorRetryClicked() {
    _state.add(_state.value.buildNew(
      viewState: WeekViewState.WHOLE_LOADING,
    ));
    _initState();
  }

  Future<void> onMarkDayCompletedClicked(BuildContext context, DateTime date) async {
    final completedMarkableDay = await _getCompletedMarkableDayToKeepStreakUsecase.invoke(date);
    if (completedMarkableDay != DateRepository.INVALID_DATE) {
      final title = AppLocalizations.of(context).warning;
      final body = AppLocalizations.of(context).getHasCompletedMarkableDay(completedMarkableDay);
      Utils.showAppDialog(context,
        title,
        body,
        null,
          () {
          _markDayCompleted(date);
        }
      );
    } else {
      _markDayCompleted(date);
    }
  }

  Future<void> _markDayCompleted(DateTime date) async {
    await _setDayMarkedCompletedUsecase.invoke(date);

    final currentWeekRecord = await _getWeekRecordUsecase.invoke(_state.value.currentDate);
    _state.add(_state.value.buildNew(
      currentWeekRecord: currentWeekRecord,
    ));

    final streakCount = await _getStreakCountUsecase.invoke(date);
    _addSeedUsecase.invoke(streakCount);
    delegator.showSeedAddedAnimation(streakCount);
  }

  Future<void> showFirstCompletableDayTutorial(BuildContext context, WeekScreenTutorialCallback callback) async {
    // just rebuild to clear flag
    _state.add(_state.value.buildNew());

    Navigator.popUntil(context, (route) => route.isFirst);
    final result = await Navigator.push(context, PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => FirstCompletableDayTutorial(
        weekScreenTutorialCallback: callback,
      ),
    ));

    if (result == true) {
      _setShownFirstCompletableDayTutorialUsecase.invoke();
      _state.add(_state.value.buildNew(
        pageViewScrollEnabled: true,
      ));
    }
  }

  void dispose() {
    delegator.removeBottomNavigationItemClickedListener(_bottomNavigationItemClickedListener);
  }
}