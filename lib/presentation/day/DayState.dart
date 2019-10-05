
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/CategoryPicker.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';

class DayState {
  static const CATEGORY_PICKERS = [
    CategoryPicker(true, AppColors.PRIMARY),
    CategoryPicker(true, AppColors.SECONDARY),
    CategoryPicker(true, AppColors.TERTIARY),
    CategoryPicker(false, AppColors.PRIMARY),
    CategoryPicker(false, AppColors.SECONDARY),
    CategoryPicker(false, AppColors.TERTIARY),
  ];

  final int year;
  final int month;
  final int day;
  final int weekday;
  final DayMemo dayMemo;
  final List<ToDoRecord> toDoRecords;
  final EditorState editorState;
  final ToDoRecord editingToDoRecord;
  final Category editingCategory;
  final List<Category> allCategories;
  final List<CategoryPicker> categoryPickers;
  final int selectedPickerIndex;

  final bool scrollToBottomEvent;
  final bool scrollToToDoListEvent;

  String get title => '$month월 $day일 ${_toWeekDayString(weekday)}';
  bool get isMemoExpanded => dayMemo?.isExpanded != false;
  bool get isFabVisible => editorState == EditorState.HIDDEN;
  DateTime get date => DateTime(year, month, day);

  const DayState({
    this.year = 0,
    this.month = 0,
    this.day = 0,
    this.weekday = 0,
    this.dayMemo = const DayMemo(),
    this.toDoRecords = const [],
    this.editorState = EditorState.HIDDEN,
    this.editingToDoRecord = const ToDoRecord(),
    this.editingCategory = const Category(),
    this.allCategories = const [],
    this.categoryPickers = CATEGORY_PICKERS,
    this.selectedPickerIndex = -1,

    this.scrollToBottomEvent = false,
    this.scrollToToDoListEvent = false,
  });

  DayState buildNew({
    int year,
    int month,
    int day,
    int weekday,
    DayMemo dayMemo,
    List<ToDoRecord> toDoRecords,
    EditorState editorState,
    ToDoRecord editingToDoRecord,
    Category editingCategory,
    List<Category> allCategories,
    int selectedPickerIndex,

    bool scrollToBottomEvent,
    bool scrollToToDoListEvent,
  }) {
    return DayState(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      weekday: weekday ?? this.weekday,
      dayMemo: dayMemo ?? this.dayMemo,
      toDoRecords: toDoRecords ?? this.toDoRecords,
      editorState: editorState ?? this.editorState,
      editingToDoRecord: editingToDoRecord ?? this.editingToDoRecord,
      editingCategory: editingCategory ?? this.editingCategory,
      allCategories: allCategories ?? this.allCategories,
      selectedPickerIndex: selectedPickerIndex ?? this.selectedPickerIndex,

      scrollToBottomEvent: scrollToBottomEvent ?? false,
      scrollToToDoListEvent: scrollToToDoListEvent ?? false,
    );
  }

  DayState buildNewToDoUpdated(ToDo updated) {
    final newRecords = List.of(toDoRecords);
    final updatedIndex = newRecords.indexWhere((it) => it.toDo.key == updated.key);
    if (updatedIndex >= 0) {
        newRecords[updatedIndex] = newRecords[updatedIndex].buildNew(toDo: updated);
    }
    return buildNew(toDoRecords: newRecords);
  }

  String _toWeekDayString(int weekDay) {
    if (weekDay == DateTime.monday) {
      return '월요일';
    } else if (weekDay == DateTime.tuesday) {
      return '화요일';
    } else if (weekDay == DateTime.wednesday) {
      return '수요일';
    } else if (weekDay == DateTime.thursday) {
      return '목요일';
    } else if (weekDay == DateTime.friday) {
      return '금요일';
    } else if (weekDay == DateTime.saturday) {
      return '토요일';
    } else {
      return '일요일';
    }
  }
}

enum EditorState {
  HIDDEN,
  SHOWN_TODO,
  SHOWN_CATEGORY,
}