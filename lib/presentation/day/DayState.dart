


import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class DayState {
  final DateTime date;
  final DayMemo dayMemo;
  final List<ToDo> toDos;

  String get title => date == null ? '' : '${date.year} ${date.month} ${date.day}일 ${_toWeekDayString(date.weekday)}';
  String get memoText => dayMemo?.text ?? '';
  String get memoHint => dayMemo?.hint ?? '';
  bool get isMemoExpanded => dayMemo?.isExpanded != false;

  const DayState({
    this.date,
    this.dayMemo,
    this.toDos = const [],
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