
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/HomeChildScreenItem.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';
import 'package:todo_app/domain/usecase/WeekUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/day/DayScreen.dart';
import 'package:todo_app/presentation/week/WeekScreenTutorial.dart';
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
      ));
    }
  }

  Future<void> _initState() async {
    final initialDate = _usecases.getToday();
    final dateInWeek = DateInWeek.fromDate(initialDate);
    final currentWeekRecord = await _usecases.getWeekRecord(initialDate);
    final prevWeekRecord = await _usecases.getWeekRecord(initialDate.subtract(_sevenDays));
    final nextWeekRecord = await _usecases.getWeekRecord(initialDate.add(_sevenDays));
    final startTutorial = !(await _usecases.hasShownWeekScreenTutorial());

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

      startTutorialEvent: startTutorial,
    ));
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

    _state.add(_state.value.buildNew(
      currentWeekRecord: currentWeekRecord,
      prevWeekRecord: prevWeekRecord,
      nextWeekRecord: nextWeekRecord,
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
    _state.add(_state.value.buildNew(
      currentWeekRecord: currentWeekRecord,
    ));
  }

  void onNextArrowClicked() {
    final newPageIndex = _state.value.currentWeekRecordPageIndex + 1;
    _state.add(_state.value.buildNew(
      currentWeekRecordPageIndex: newPageIndex,
      animateToPageEvent: newPageIndex,
    ));
  }

  void onPrevArrowClicked() {
    final newPageIndex = _state.value.currentWeekRecordPageIndex - 1;
    _state.add(_state.value.buildNew(
      currentWeekRecordPageIndex: newPageIndex,
      animateToPageEvent: newPageIndex,
    ));
  }

  void startTutorial(BuildContext context, ViewLayoutInfo memoPosition) {
    Navigator.push(context, PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => WeekScreenTutorial(
        memoViewInfo: memoPosition,
      ),
    ));
  }

  void dispose() {
    delegator.removeBottomNavigationItemClickedListener(_bottomNavigationItemClickedListener);
  }
}