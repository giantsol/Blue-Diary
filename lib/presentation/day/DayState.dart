
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';

class DayState {
  final int month;
  final int day;
  final int weekday;
  final DayMemo dayMemo;
  final List<ToDoRecord> toDoRecords;
  final StickyInputState stickyInputState;
  final ToDoRecord editingToDoRecord;
  final String toDoEditorText;
  final List<Category> allCategories;

  String get title => '$month월 $day일 ${_toWeekDayString(weekday)}';
  bool get isMemoExpanded => dayMemo?.isExpanded != false;
  Category get editingCategory => editingToDoRecord.category;
  bool get isFabVisible => stickyInputState == StickyInputState.HIDDEN;

  const DayState({
    this.month = 0,
    this.day = 0,
    this.weekday = 0,
    this.dayMemo = const DayMemo(),
    this.toDoRecords = const [],
    this.stickyInputState = StickyInputState.HIDDEN,
    this.editingToDoRecord = const ToDoRecord(),
    this.toDoEditorText = '',
    this.allCategories = const [],
  });

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

enum StickyInputState {
  HIDDEN,
  SHOWN_TODO,
  SHOWN_CATEGORY,
}