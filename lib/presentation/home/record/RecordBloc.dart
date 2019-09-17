
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
    final today = _usecases.getToday();
    final dateInNthWeek = _usecases.getCurrentDateInNthWeek();
    final weekMemos = await _usecases.getCurrentWeekMemos();
    final currentDayRecord = await _usecases.getCurrentDayRecord();
    final prevDayRecord = await _usecases.getPrevDayRecord();
    final nextDayRecord = await _usecases.getNextDayRecord();

    _state.add(_state.value.buildNew(
      today: today,
      dayRecordPageIndex: dayRecordPageIndex ?? _state.value.dayRecordPageIndex,
      dateInNthWeek: dateInNthWeek,
      weekMemos: weekMemos,
      currentDayRecord: currentDayRecord,
      prevDayRecord: prevDayRecord,
      nextDayRecord: nextDayRecord,
    ));
  }

  onYearAndMonthNthWeekClicked() {
    delegator?.updateCurrentDrawerChildScreenItem(DrawerChildScreenItem.KEY_CALENDAR);
  }

  onWeekMemoTextChanged(WeekMemo weekMemo, String changed) {
    final updatedWeekMemo = weekMemo.buildNew(content: changed);
    _state.add(_state.value.buildNewWeekMemoUpdated(updatedWeekMemo));
    _usecases.saveWeekMemo(updatedWeekMemo);
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
    final updatedDayRecord = dayRecord.buildNewToDoAdded();
    _state.add(_state.value.buildNewDayRecordUpdated(updatedDayRecord));
  }

  onToDoTextChanged(DayRecord dayRecord, ToDo toDo, String changed) {
    final updatedToDo = toDo.buildNew(content: changed);
    final updatedDayRecord = dayRecord.buildNewToDoUpdated(updatedToDo);
    _state.add(_state.value.buildNewDayRecordUpdated(updatedDayRecord));
    _usecases.saveToDo(updatedToDo);
  }

  onToDoCheckBoxClicked(DayRecord dayRecord, ToDo toDo) {
    if (!toDo.isDone) {
      final updatedToDo = toDo.buildNew(isDone: true);
      final updatedDayRecord = dayRecord.buildNewToDoUpdated(updatedToDo);
      _state.add(_state.value.buildNewDayRecordUpdated(updatedDayRecord));
      _usecases.saveToDo(updatedToDo);
    }
  }

  onToDoDismissed(DayRecord dayRecord, ToDo toDo) {
    final updatedDayRecord = dayRecord.buildNewToDoRemoved(toDo);
    _state.add(_state.value.buildNewDayRecordUpdated(updatedDayRecord));
    _usecases.removeToDo(toDo);
  }

  onDayMemoTextChanged(DayRecord dayRecord, String changed) {
    final updatedDayRecord = dayRecord.buildNew(memo: dayRecord.memo.buildNew(content: changed));
    _state.add(_state.value.buildNewDayRecordUpdated(updatedDayRecord));
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