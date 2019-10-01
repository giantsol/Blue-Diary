


import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';

class DayState {
  static DayState createDummy() {
    return DayState(
      date: DateTime(2019, 9, 30),
      toDoRecords: [
        ToDoRecord(toDo: ToDo(index: 0, text: 'develop kakaotalk', isDone: true), category: Category()),
        ToDoRecord(toDo: ToDo(index: 1, text: '다음앱 개발', isDone: true), category: Category(id: 1, name: '공부', fillColor: 0xffbbeaa6)),
        ToDoRecord(toDo: ToDo(index: 2, text: '운동 한다'), category: Category(id: 2, name: '운동', borderColor: 0xff394a6d)),
        ToDoRecord(toDo: ToDo(index: 3, text: '운동'), category: Category(id: 3, name: '운동2', fillColor: 0xffcc4198)),
        ToDoRecord(toDo: ToDo(index: 3, text: '운동'), category: Category(id: 3, name: '운동2', fillColor: 0xffcc4198)),
        ToDoRecord(toDo: ToDo(index: 3, text: '운동'), category: Category(id: 3, name: '운동2', fillColor: 0xffcc4198)),
        ToDoRecord(toDo: ToDo(index: 3, text: '운동'), category: Category(id: 3, name: '운동2', fillColor: 0xffcc4198)),
        ToDoRecord(toDo: ToDo(index: 3, text: '운동'), category: Category(id: 3, name: '운동2', fillColor: 0xffcc4198)),
        ToDoRecord(toDo: ToDo(index: 3, text: '운동'), category: Category(id: 3, name: '운동2', fillColor: 0xffcc4198)),
        ToDoRecord(toDo: ToDo(index: 3, text: '운동'), category: Category(id: 3, name: '운동2', fillColor: 0xffcc4198)),
      ],
      stickyInputState: StickyInputState.SHOWN_TODO,
    );
  }

  final DateTime date;
  final DayMemo dayMemo;
  final List<ToDoRecord> toDoRecords;
  final StickyInputState stickyInputState;
  final ToDoRecord editingToDoRecord;
  final String toDoEditorText;

  String get title => date == null ? '' : '${date.month}월 ${date.day}일 ${_toWeekDayString(date.weekday)}';
  String get memoText => dayMemo?.text ?? '';
  String get memoHint => dayMemo?.hint ?? '';
  bool get isMemoExpanded => dayMemo?.isExpanded != false;

  const DayState({
    this.date,
    this.dayMemo,
    this.toDoRecords = const [],
    this.stickyInputState = StickyInputState.HIDDEN,
    this.editingToDoRecord,
    this.toDoEditorText = '',
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