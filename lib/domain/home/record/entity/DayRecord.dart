
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

    return '$month월 $day일 $weekday';
  }

}