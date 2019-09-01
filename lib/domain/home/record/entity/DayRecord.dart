
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/ToDo.dart';

class DayRecord {
  final DateTime dateTime;
  final List<ToDo> todos;
  final DayMemo memo;

  const DayRecord(this.dateTime, this.todos, this.memo);

  DayRecord getModified({
    DateTime dateTime,
    List<ToDo> todos,
    DayMemo memo,
  }) {
    return DayRecord(
      dateTime ?? this.dateTime,
      todos ?? this.todos,
      memo ?? this.memo,
    );
  }

  String get title {
    final day = dateTime.day;
    switch (dateTime.weekday) {
      case DateTime.monday:
        return '$day일 월';
      case DateTime.tuesday:
        return '$day일 화';
      case DateTime.wednesday:
        return '$day일 수';
      case DateTime.thursday:
        return '$day일 목';
      case DateTime.friday:
        return '$day일 금';
      case DateTime.saturday:
        return '$day일 토';
      default:
        return '$day일 일';
    }
  }

}