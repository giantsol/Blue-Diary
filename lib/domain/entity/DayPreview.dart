
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class DayPreview {
  final DateTime date;
  final List<ToDo> toDos;
  final bool isLocked;
  final bool hasTrailingDots;
  final bool isToday;

  String get thumbnailString {
    final weekday = date.weekday;
    if (weekday == DateTime.monday) {
      return 'Mon';
    } else if (weekday == DateTime.tuesday) {
      return 'Tue';
    } else if (weekday == DateTime.wednesday) {
      return 'Wed';
    } else if (weekday == DateTime.thursday) {
      return 'Thu';
    } else if (weekday == DateTime.friday) {
      return 'Fri';
    } else if (weekday == DateTime.saturday) {
      return 'Sat';
    } else {
      return 'Sun';
    }
  }
  String get title => '${date.month}월 ${date.day}일';
  int get totalToDosCount => toDos.length;
  int get doneToDosCount => toDos.where((toDo) => toDo.isDone).length;
  bool get hasBorder => totalToDosCount > 0;
  double get filledRatio => totalToDosCount == 0 ? 0 : doneToDosCount / totalToDosCount.toDouble();
  String get subtitle => totalToDosCount == 0 ? 'No Todos' : '$doneToDosCount/$totalToDosCount achieved';
  Color get subtitleColor => totalToDosCount == 0 ? AppColors.textBlackLight : AppColors.primary;

  const DayPreview(this.date, this.toDos, this.isLocked, this.hasTrailingDots, this.isToday);
}