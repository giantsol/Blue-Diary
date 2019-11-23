
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
import 'package:todo_app/domain/usecase/WeekUsecases.dart';
import 'package:todo_app/presentation/App.dart';
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

  final WeekUsecases _usecases = dependencies.weekUsecases;

  WeekBlocDelegator delegator;

  WeekBloc({
    @required this.delegator
  }) {
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
    final initialDate = await _usecases.getToday();
    if (initialDate == DateRepository.INVALID_DATE) {
      _state.add(_state.value.buildNew(
        viewState: WeekViewState.NETWORK_ERROR,
      ));
    } else {
      _usecases.setRealFirstLaunchDateIfNotExists(initialDate);

      final dateInWeek = DateInWeek.fromDate(initialDate);
      final currentWeekRecord = await _usecases.getWeekRecord(initialDate);
      final prevWeekRecord = await _usecases.getWeekRecord(initialDate.subtract(_sevenDays));
      final nextWeekRecord = await _usecases.getWeekRecord(initialDate.add(_sevenDays));
      final startTutorial = !(await _usecases.hasShownWeekScreenTutorial());
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

    final currentWeekRecord = await _usecases.getWeekRecord(currentDate);
    final prevWeekRecord = await _usecases.getWeekRecord(currentDate.subtract(_sevenDays));
    final nextWeekRecord = await _usecases.getWeekRecord(currentDate.add(_sevenDays));
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
    _usecases.setCheckPoint(checkPoint);
  }

  Future<void> onDayPreviewClicked(BuildContext context, DayPreview dayPreview) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayScreen(dayPreview.date),
      ),
    );

    final currentWeekRecord = await _usecases.getWeekRecord(_state.value.currentDate);
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

    _usecases.setShownWeekScreenTutorial();

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
    final completedMarkableDay = await _usecases.getCompletedMarkableDayToKeepStreakBefore(date);
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
    _usecases.setDayMarkedCompleted(date);

    final currentWeekRecord = await _usecases.getWeekRecord(_state.value.currentDate);
    _state.add(_state.value.buildNew(
      currentWeekRecord: currentWeekRecord,
    ));
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
      _usecases.setShownFirstCompletableDayTutorial();
      _state.add(_state.value.buildNew(
        pageViewScrollEnabled: true,
      ));
    }
  }

  void dispose() {
    delegator.removeBottomNavigationItemClickedListener(_bottomNavigationItemClickedListener);
  }
}