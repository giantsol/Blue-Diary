
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';
import 'package:todo_app/domain/usecase/RecordUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/record/RecordBlocDelegator.dart';
import 'package:todo_app/presentation/home/record/RecordState.dart';

class RecordBloc {
  RecordBlocDelegator delegator;

  final _state = BehaviorSubject<RecordState>.seeded(RecordState());
  RecordState getInitialState() => _state.value;
  Stream<RecordState> observeState() => _state.distinct();

  final RecordUsecases _usecases = dependencies.recordUsecases;

  RecordBloc({this.delegator}) {
    _initState();
  }

  _initState({int dayRecordPageIndex}) async {
    final dateInNthWeek = _usecases.getCurrentDateInNthWeek();
    final weekMemos = await _usecases.getCurrentWeekMemos();
    final currentDayRecord = await _usecases.getCurrentDayRecord();
    final prevDayRecord = await _usecases.getPrevDayRecord();
    final nextDayRecord = await _usecases.getNextDayRecord();
    final today = _usecases.getToday();

    var goToTodayButtonVisibility;
    if (prevDayRecord.isToday || today.difference(currentDayRecord.dateTime).inDays < 0) {
      goToTodayButtonVisibility = GoToTodayButtonVisibility.LEFT;
    } else if (nextDayRecord.isToday || today.difference(currentDayRecord.dateTime).inDays > 0) {
      goToTodayButtonVisibility = GoToTodayButtonVisibility.RIGHT;
    } else {
      goToTodayButtonVisibility = GoToTodayButtonVisibility.GONE;
    }
    _state.add(_state.value.getModified(
      dayRecordPageIndex: dayRecordPageIndex ?? _state.value.dayRecordPageIndex,
      dateInNthWeek: dateInNthWeek,
      weekMemos: weekMemos,
      currentDayRecord: currentDayRecord,
      prevDayRecord: prevDayRecord,
      nextDayRecord: nextDayRecord,
      goToTodayButtonVisibility: goToTodayButtonVisibility,
    ));
  }

  onYearAndMonthNthWeekClicked() {
    delegator?.updateCurrentDrawerChildScreenItem(DrawerChildScreenItem.KEY_CALENDAR);
  }

  onWeekMemoTextChanged(WeekMemo weekMemo, String changed) {
    final updatedWeekMemo = weekMemo.getModified(content: changed);
    final currentWeekMemos = _state.value.weekMemos;
    final index = currentWeekMemos.indexWhere((it) => it.key == updatedWeekMemo.key);
    if (index >= 0) {
      currentWeekMemos[index] = updatedWeekMemo;
      _state.add(_state.value.getModified(weekMemos: currentWeekMemos));
      _usecases.saveWeekMemo(updatedWeekMemo);
    }
  }

  onDayRecordsPageChanged(int newIndex) {
    final curIndex = _state.value.dayRecordPageIndex;
    if ((curIndex == 0 && newIndex == 1)
      || (curIndex == 1 && newIndex == 2)
      || (curIndex == 2 && newIndex == 0)) {
      _usecases.changeCurrentDateByDay(1);
    } else {
      _usecases.changeCurrentDateByDay(-1);
    }
    _initState(dayRecordPageIndex: newIndex);
  }

  onAddToDoClicked(DayRecord dayRecord) {
    final updatedDayRecord = dayRecord.getToDoAdded();
    _state.add(_state.value.getDayRecordModified(updatedDayRecord));
  }

  onToDoTextChanged(DayRecord dayRecord, ToDo toDo, String changed) {
    final updatedToDo = toDo.getModified(content: changed);
    final updatedDayRecord = dayRecord.getToDoUpdated(toDo);
    _state.add(_state.value.getDayRecordModified(updatedDayRecord));
    _usecases.saveToDo(updatedToDo);
  }

  onToDoCheckBoxClicked(DayRecord dayRecord, ToDo toDo) {
    if (!toDo.isDone) {
      final updatedToDo = toDo.getModified(isDone: true);
      final updatedDayRecord = dayRecord.getToDoUpdated(updatedToDo);
      _state.add(_state.value.getDayRecordModified(updatedDayRecord));
      _usecases.saveToDo(updatedToDo);
    }
  }

  onToDoDismissed(DayRecord dayRecord, ToDo toDo) {
    final updatedDayRecord = dayRecord.getToDoRemoved(toDo);
    if (updatedDayRecord != null) {
      _state.add(_state.value.getDayRecordModified(updatedDayRecord));
      _usecases.removeToDo(toDo);
    }
  }

  onDayMemoTextChanged(DayRecord dayRecord, String changed) {
    final updatedDayRecord = dayRecord.getModified(memo: dayRecord.memo.getModified(content: changed));
    _state.add(_state.value.getDayRecordModified(updatedDayRecord));
    _usecases.saveDayMemo(updatedDayRecord.memo);
  }

  onGoToTodayButtonClicked() {
    _usecases.setCurrentDateToToday();
    _initState();
  }

  dispose() {
    _state.close();
  }
}