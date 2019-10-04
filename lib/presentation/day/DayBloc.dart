
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/usecase/DayUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/day/DayState.dart';

class DayBloc {
  final _state = BehaviorSubject<DayState>.seeded(DayState());
  DayState getInitialState() => _state.value;
  Stream<DayState> observeState() => _state.distinct();

  final DayUsecases _usecases = dependencies.dayUsecases;

  DayBloc(DayRecord dayRecord) {
    _initState(dayRecord);
  }

  Future<void> _initState(DayRecord dayRecord) async {
    final date = DateTime(dayRecord.year, dayRecord.month, dayRecord.day);
    final toDoRecords = await _usecases.getToDoRecords(date);
    _state.add(_state.value.buildNew(
      month: dayRecord.month,
      day: dayRecord.day,
      weekday: dayRecord.weekday,
      dayMemo: dayRecord.dayMemo,
      toDoRecords: toDoRecords,
    ));
  }

  void onBackArrowClicked(BuildContext context) {
    Navigator.pop(context);
  }

  void onAddToDoClicked(BuildContext context) {
    _state.add(_state.value.buildNew(
      editorState: EditorState.SHOWN_TODO,
    ));
  }

  void onDayMemoCollapseOrExpandClicked() {
    final current = _state.value.dayMemo;
    final updated = current.buildNew(isExpanded: !current.isExpanded);
    _state.add(_state.value.buildNew(
      dayMemo: updated,
    ));
    _usecases.setDayMemo(updated);
  }

  void onDayMemoTextChanged(String changed) {
    final updated = _state.value.dayMemo.buildNew(text: changed);
    _state.add(_state.value.buildNew(
      dayMemo: updated,
    ));
    _usecases.setDayMemo(updated);
  }

  void onToDoCheckBoxClicked(ToDo toDo) {
    final updated = toDo.buildNew(isDone: true);
    _state.add(_state.value.buildNewToDoUpdated(updated));
    _usecases.setToDo(updated);
  }

  void onEditingCategoryTextChanged(String changed) {
    final currentEditingRecord = _state.value.editingToDoRecord;
    final updated = currentEditingRecord.buildNew(category: currentEditingRecord.category.buildNew(name: changed));
    _state.add(_state.value.buildNew(editingToDoRecord: updated));
  }

  bool onWillPopScope() {
    final editorState = _state.value.editorState;
    if (editorState == EditorState.SHOWN_CATEGORY) {
      _state.add(_state.value.buildNew(
        editorState: EditorState.SHOWN_TODO,
      ));
      return false;
    } else if (editorState == EditorState.SHOWN_TODO) {
      _state.add(_state.value.buildNew(
        editorState: EditorState.HIDDEN,
      ));
      return false;
    }
    return true;
  }

  void dispose() {
    _state.close();
  }
}