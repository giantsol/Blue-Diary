
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/CategoryPicker.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/domain/usecase/DayUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/day/DayState.dart';

class DayBloc {
  final _state = BehaviorSubject<DayState>.seeded(DayState());
  DayState getInitialState() => _state.value;
  Stream<DayState> observeState() => _state.distinct();

  final DayUsecases _usecases = dependencies.dayUsecases;

  DayBloc(DateTime date) {
    _initState(date);
  }

  Future<void> _initState(DateTime date, {bool scrollToBottom}) async {
    final toDoRecords = await _usecases.getToDoRecords(date);
    final dayMemo = await _usecases.getDayMemo(date);
    final nextOrder = toDoRecords.isEmpty ? 0 : toDoRecords.last.toDo.order + 1;
    final editingToDoRecord = ToDoRecord.createDraft(_state.value.date, nextOrder);
    final editingCategory = editingToDoRecord.category.buildNew();
    final allCategories = await _usecases.getAllCategories();
    _state.add(_state.value.buildNew(
      year: date.year,
      month: date.month,
      day: date.day,
      weekday: date.weekday,
      dayMemo: dayMemo,
      toDoRecords: toDoRecords,
      editingToDoRecord: editingToDoRecord,
      editingCategory: editingCategory,
      allCategories: allCategories,
      scrollToBottomEvent: scrollToBottom,
    ));
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

  void onBackArrowClicked(BuildContext context) {
    Navigator.pop(context);
  }

  void onAddToDoClicked(BuildContext context) {
    final toDoRecords = _state.value.toDoRecords;
    final nextOrder = toDoRecords.isEmpty ? 0 : toDoRecords.last.toDo.order + 1;
    final draft = ToDoRecord.createDraft(_state.value.date, nextOrder);
    final draftCategory = draft.category.buildNew();
    _state.add(_state.value.buildNew(
      editingToDoRecord: draft,
      editingCategory: draftCategory,
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
    _state.add(_state.value.buildNew(
      editingCategory: _state.value.editingCategory.buildNew(name: changed),
    ));
  }

  void onEditingToDoTextChanged(String changed) {
    final currentEditingRecord = _state.value.editingToDoRecord;
    final updated = currentEditingRecord.buildNew(toDo: currentEditingRecord.toDo.buildNew(text: changed));
    _state.add(_state.value.buildNew(editingToDoRecord: updated));
  }

  void onToDoRecordItemClicked(ToDoRecord toDoRecord) {
    _state.add(_state.value.buildNew(
      editingToDoRecord: toDoRecord.buildNew(),
      editingCategory: toDoRecord.category.buildNew(),
      editorState: EditorState.SHOWN_TODO,
    ));
  }

  Future<void> onToDoEditingDone() async {
    final editedRecord = _state.value.editingToDoRecord.buildNew(isDraft: false);
    await _usecases.setToDoRecord(editedRecord);

    _initState(_state.value.date, scrollToBottom: true);
  }

  void onEditorCategoryButtonClicked() {
    _state.add(_state.value.buildNew(
      editingCategory: _state.value.editingToDoRecord.category.buildNew(),
      selectedPickerIndex: -1,
      editorState: EditorState.SHOWN_CATEGORY,
    ));
  }

  void onToDoRecordDismissed(ToDoRecord toDoRecord) {
    final toDoRecords = _state.value.toDoRecords;
    final removedIndex = toDoRecords.indexWhere((it) => it.toDo.key == toDoRecord.toDo.key);
    if (removedIndex >= 0) {
      final newRecords = List.of(toDoRecords);
      newRecords.removeAt(removedIndex);
      _state.add(_state.value.buildNew(
        toDoRecords: newRecords,
      ));
    }
    _usecases.removeToDo(toDoRecord.toDo);
  }

  void onCategoryEditorCategoryClicked(Category category) {
    final recordWithNewCategory = _state.value.editingToDoRecord.buildNew(category: category);
    _state.add(_state.value.buildNew(
      editingToDoRecord: recordWithNewCategory,
      editingCategory: category,
      editorState: EditorState.SHOWN_TODO,
    ));
  }

  void onChoosePhotoClicked() {

  }

  void onCategoryPickerSelected(CategoryPicker item) {
    final updatedCategory = item.isFillType ? _state.value.editingCategory.buildNew(
      fillColor: item.color,
      borderColor: Category.COLOR_INVALID,
      imagePath: '',
    ) : _state.value.editingCategory.buildNew(
      fillColor: Category.COLOR_INVALID,
      borderColor: item.color,
      imagePath: '',
    );
    final index = _state.value.categoryPickers.indexWhere((it) => it == item);
    _state.add(_state.value.buildNew(
      editingCategory: updatedCategory,
      selectedPickerIndex: index,
    ));
  }

  void onCreateNewCategoryClicked() {
    final newCategory = _state.value.editingCategory.buildNew(id: Category.ID_NEW);
    final recordWithNewCategory = _state.value.editingToDoRecord.buildNew(category: newCategory);
    _state.add(_state.value.buildNew(
      editingToDoRecord: recordWithNewCategory,
      editingCategory: newCategory,
      editorState: EditorState.SHOWN_TODO,
    ));
  }

  void onModifyCategoryClicked() {
    final recordWithNewCategory = _state.value.editingToDoRecord.buildNew(category: _state.value.editingCategory);
    _state.add(_state.value.buildNew(
      editingToDoRecord: recordWithNewCategory,
      editorState: EditorState.SHOWN_TODO,
    ));
  }

  void dispose() {
    _state.close();
  }
}