
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/CategoryPicker.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/domain/usecase/DayUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/day/DayState.dart';

class DayBloc {
  static const _oneDay = const Duration(days: 1);

  final _state = BehaviorSubject<DayState>.seeded(DayState());
  DayState getInitialState() => _state.value;
  Stream<DayState> observeState() => _state.distinct();

  final DayUsecases _usecases = dependencies.dayUsecases;

  DayBloc(DateTime date) {
    _initState(date);
  }

  // initialDate is the date user clicked in WeekScreen to enter DayScreen
  Future<void> _initState(DateTime initialDate) async {
    final currentDate = initialDate;
    final currentDayRecord = await _usecases.getDayRecord(currentDate);
    final prevDayRecord = await _usecases.getDayRecord(currentDate.subtract(_oneDay));
    final nextDayRecord = await _usecases.getDayRecord(currentDate.add(_oneDay));
    final allCategories = await _usecases.getAllCategories();

    final editingToDoRecord = _createDraftToDoRecord(currentDate, currentDayRecord.toDoRecords);
    final editingCategory = editingToDoRecord.category.buildNew();
    _state.add(_state.value.buildNew(
      viewState: DayViewState.NORMAL,
      editingToDoRecord: editingToDoRecord,
      editingCategory: editingCategory,
      allCategories: allCategories,
      currentDayRecord: currentDayRecord,
      prevDayRecord: prevDayRecord,
      nextDayRecord: nextDayRecord,
      initialDate: initialDate,
      currentDate: currentDate,
    ));
  }

  Future<void> onDayRecordPageIndexChanged(int newIndex) async {
    final currentDate = _state.value.initialDate.add(Duration(days: newIndex - _state.value.initialDayRecordPageIndex));

    // update date text first for smoother UI
    _state.add(_state.value.buildNew(
      currentDate: currentDate,
      currentDayRecordPageIndex: newIndex,
    ));

    final currentDayRecord = await _usecases.getDayRecord(currentDate);
    final prevDayRecord = await _usecases.getDayRecord(currentDate.subtract(_oneDay));
    final nextDayRecord = await _usecases.getDayRecord(currentDate.add(_oneDay));
    final editingToDoRecord = _createDraftToDoRecord(currentDate, currentDayRecord.toDoRecords);
    final editingCategory = editingToDoRecord.category.buildNew();

    _state.add(_state.value.buildNew(
      viewState: DayViewState.NORMAL,
      editorState: EditorState.HIDDEN,
      editingToDoRecord: editingToDoRecord,
      editingCategory: editingCategory,
      currentDayRecord: currentDayRecord,
      prevDayRecord: prevDayRecord,
      nextDayRecord: nextDayRecord,
    ));
  }

  ToDoRecord _createDraftToDoRecord(DateTime date, List<ToDoRecord> currentRecords) {
    final nextOrder = currentRecords.isEmpty ? 0 : currentRecords.last.toDo.order + 1;
    return ToDoRecord.createDraft(date, nextOrder);
  }

  bool handleBackPress() {
    final editorState = _state.value.editorState;
    if (editorState == EditorState.SHOWN_CATEGORY) {
      _state.add(_state.value.buildNew(
        editorState: EditorState.SHOWN_TODO,
      ));
      return true;
    } else if (editorState == EditorState.SHOWN_TODO) {
      _state.add(_state.value.buildNew(
        editorState: EditorState.HIDDEN,
      ));
      return true;
    }
    return false;
  }

  void onBackArrowClicked(BuildContext context) {
    Navigator.pop(context);
  }

  void onAddToDoClicked(BuildContext context) {
    final currentDayRecord = _state.value.currentDayRecord;
    final toDoRecords = currentDayRecord.toDoRecords;
    final draft = _createDraftToDoRecord(_state.value.currentDate, toDoRecords);
    final draftCategory = draft.category.buildNew();
    _state.add(_state.value.buildNew(
      editingToDoRecord: draft,
      editingCategory: draftCategory,
      editorState: EditorState.SHOWN_TODO,
      scrollToToDoListEvent: true,
    ));
  }

  void onDayMemoCollapseOrExpandClicked() {
    final currentDayRecord = _state.value.currentDayRecord;
    final currentDayMemo = currentDayRecord.dayMemo;
    final updatedDayMemo = currentDayMemo.buildNew(isExpanded: !currentDayMemo.isExpanded);
    final updatedDayRecord = currentDayRecord.buildNew(dayMemo: updatedDayMemo);
    _state.add(_state.value.buildNew(
      currentDayRecord: updatedDayRecord,
    ));
    _usecases.setDayMemo(updatedDayMemo);
  }

  void onDayMemoTextChanged(String changed) {
    final currentDayRecord = _state.value.currentDayRecord;
    final currentDayMemo = currentDayRecord.dayMemo;
    final updatedDayMemo = currentDayMemo.buildNew(text: changed);
    final updatedDayRecord = currentDayRecord.buildNew(dayMemo: updatedDayMemo);
    _state.add(_state.value.buildNew(
      currentDayRecord: updatedDayRecord,
    ));
    _usecases.setDayMemo(updatedDayMemo);
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
      scrollToToDoListEvent: true,
    ));
  }

  Future<void> onToDoEditingDone() async {
    if (_state.value.editingToDoRecord.toDo.text.length == 0) {
      return;
    }

    final editedRecord = _state.value.editingToDoRecord.buildNew(isDraft: false);
    await _usecases.setToDoRecord(editedRecord);

    final currentDayRecord = _state.value.currentDayRecord;
    final toDoRecords = await _usecases.getToDoRecords(_state.value.currentDate);
    final updatedDayRecord = currentDayRecord.buildNew(toDoRecords: toDoRecords);

    final editingToDoRecord = _createDraftToDoRecord(_state.value.currentDate, toDoRecords);
    final editingCategory = editingToDoRecord.category.buildNew();

    _state.add(_state.value.buildNew(
      editingToDoRecord: editingToDoRecord,
      editingCategory: editingCategory,
      currentDayRecord: updatedDayRecord,
      scrollToBottomEvent: true,
    ));
  }

  void onEditorCategoryButtonClicked() {
    _state.add(_state.value.buildNew(
      editingCategory: _state.value.editingToDoRecord.category.buildNew(),
      selectedPickerIndex: -1,
      editorState: EditorState.SHOWN_CATEGORY,
    ));
  }

  void onToDoRecordItemLongClicked(BuildContext context, ToDoRecord toDoRecord) {
    Utils.showAppDialog(context,
      AppLocalizations.of(context).removeToDo,
      AppLocalizations.of(context).removeToDoBody,
        null,
        () => _onRemoveToDoOkClicked(toDoRecord.toDo));
  }

  void _onRemoveToDoOkClicked(ToDo toDo) {
    final currentDayRecord = _state.value.currentDayRecord;
    final toDoRecords = currentDayRecord.toDoRecords;
    final removedIndex = toDoRecords.indexWhere((it) => it.toDo.key == toDo.key);
    if (removedIndex >= 0) {
      final newRecords = List.of(toDoRecords);
      newRecords.removeAt(removedIndex);
      final updatedDayRecord = currentDayRecord.buildNew(toDoRecords: newRecords);
      _state.add(_state.value.buildNew(
        currentDayRecord: updatedDayRecord,
      ));
    }
    _usecases.removeToDo(toDo);
  }

  void onCategoryEditorCategoryClicked(Category category) {
    final recordWithNewCategory = _state.value.editingToDoRecord.buildNew(category: category);
    _state.add(_state.value.buildNew(
      editingToDoRecord: recordWithNewCategory,
      editingCategory: category,
      editorState: EditorState.SHOWN_TODO,
    ));
  }

  Future<void> onChoosePhotoClicked() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final updatedCategory = _state.value.editingCategory.buildNew(
      fillColor: Category.COLOR_INVALID,
      borderColor: Category.COLOR_INVALID,
      imagePath: imageFile.path,
    );
    _state.add(_state.value.buildNew(
      editingCategory: updatedCategory,
      selectedPickerIndex: -1,
    ));
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

  Future<void> onCreateNewCategoryClicked() async {
    final newCategoryId = await _usecases.setCategory(_state.value.editingCategory.buildNew(id: Category.ID_NEW));
    final newCategory = _state.value.editingCategory.buildNew(id: newCategoryId);
    final recordWithNewCategory = _state.value.editingToDoRecord.buildNew(category: newCategory);

    final allCategories = await _usecases.getAllCategories();

    _state.add(_state.value.buildNew(
      editingToDoRecord: recordWithNewCategory,
      editingCategory: newCategory,
      editorState: EditorState.SHOWN_TODO,
      allCategories: allCategories,
    ));
  }

  Future<void> onModifyCategoryClicked() async {
    final modifiedCategory = _state.value.editingCategory;
    final recordWithNewCategory = _state.value.editingToDoRecord.buildNew(category: modifiedCategory);

    await _usecases.setCategory(modifiedCategory);
    final currentDayRecord = _state.value.currentDayRecord;
    final toDoRecords = await _usecases.getToDoRecords(_state.value.currentDate);
    final updatedDayRecord = currentDayRecord.buildNew(toDoRecords: toDoRecords);
    final allCategories = await _usecases.getAllCategories();

    _state.add(_state.value.buildNew(
      editingToDoRecord: recordWithNewCategory,
      editorState: EditorState.SHOWN_TODO,
      allCategories: allCategories,
      currentDayRecord: updatedDayRecord,
    ));
  }

  void onCategoryEditorCategoryLongClicked(BuildContext context, Category category) {
    if (category.id == Category.ID_DEFAULT) {
      return;
    }

    Utils.showAppDialog(context,
      AppLocalizations.of(context).removeCategory,
      AppLocalizations.of(context).removeCategoryBody,
        null,
        () => _onRemoveCategoryOkClicked(context, category));
  }

  Future<void> _onRemoveCategoryOkClicked(BuildContext context, Category category) async {
    await _usecases.removeCategory(category);
    final currentDayRecord = _state.value.currentDayRecord;
    final toDoRecords = await _usecases.getToDoRecords(_state.value.currentDate);
    final updatedDayRecord = currentDayRecord.buildNew(toDoRecords: toDoRecords);
    final allCategories = await _usecases.getAllCategories();
    _state.add(_state.value.buildNew(
      allCategories: allCategories,
      currentDayRecord: updatedDayRecord,
    ));
  }

  void onNextArrowClicked() {
    final newPageIndex = _state.value.currentDayRecordPageIndex + 1;
    _state.add(_state.value.buildNew(
      currentDayRecordPageIndex: newPageIndex,
      animateToPageEvent: newPageIndex,
    ));
  }

  void onPrevArrowClicked() {
    final newPageIndex = _state.value.currentDayRecordPageIndex - 1;
    _state.add(_state.value.buildNew(
      currentDayRecordPageIndex: newPageIndex,
      animateToPageEvent: newPageIndex,
    ));
  }

  void onBackFABClicked(BuildContext context) {
    Navigator.pop(context);
  }

  void onToDoEditorCancelClicked() {
    handleBackPress();
  }

  void onCategoryEditorCancelClicked() {
    handleBackPress();
  }
}