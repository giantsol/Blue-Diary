
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class DayRecord {
  final DateTime dateTime;
  final List<ToDo> toDos;
  final DayMemo memo;
  final bool isToday;
  final bool isSelected;

  const DayRecord(this.dateTime, this.toDos, this.memo, this.isToday, this.isSelected);

  String get title {
    final month = dateTime.month;
    final day = dateTime.day;
    var weekday;
    switch (dateTime.weekday) {
      case DateTime.monday:
        weekday = '월';
        break;
      case DateTime.tuesday:
        weekday = '화';
        break;
      case DateTime.wednesday:
        weekday = '수';
        break;
      case DateTime.thursday:
        weekday = '목';
        break;
      case DateTime.friday:
        weekday = '금';
        break;
      case DateTime.saturday:
        weekday = '토';
        break;
      default:
        weekday = '일';
    }

    if (isToday) {
      return '$month월 $day일 $weekday (오늘)';
    } else {
      return '$month월 $day일 $weekday';
    }
  }

  String get key => title;

  DayRecord getModified({
    DateTime dateTime,
    List<ToDo> todos,
    DayMemo memo,
    bool isToday,
    bool isSelected,
  }) {
    return DayRecord(
      dateTime ?? this.dateTime,
      todos ?? this.toDos,
      memo ?? this.memo,
      isToday ?? this.isToday,
      isSelected ?? this.isSelected,
    );
  }

  DayRecord getToDoAdded() {
    return getModified(todos: toDos..add(ToDo(dateTime, toDos.length)));
  }

  DayRecord getToDoUpdated(ToDo toDo) {
    final updatedIndex = toDos.indexWhere((it) => it.key == toDo.key);
    if (updatedIndex >= 0) {
      return getModified(todos: toDos..[updatedIndex] = toDo);
    } else {
      return this;
    }
  }

  DayRecord getToDoRemoved(ToDo toDo) {
    final removeIndex = toDos.indexWhere((it) => it.key == toDo.key);
    if (removeIndex >= 0) {
      return getModified(todos: toDos..removeAt(removeIndex));
    }
    return null;
  }

}