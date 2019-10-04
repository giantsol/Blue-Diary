
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class DayRecord {
  final int year;
  final int month;
  final int day;
  final int weekday;
  final List<ToDo> toDos;
  final bool isLocked;
  final bool isToday;

  bool get hasTrailingDots => weekday != DateTime.sunday;
  String get key => '$year-$month-$day';
  String get title => '$month월 $day일';
  int get totalToDosCount => toDos.length;
  int get doneToDosCount => toDos.where((toDo) => toDo.isDone).length;
  bool get hasBorder => totalToDosCount > 0;
  double get filledRatio => totalToDosCount == 0 ? 0 : doneToDosCount / totalToDosCount.toDouble();
  String get subtitle => totalToDosCount == 0 ? 'No Todos' : '$doneToDosCount/$totalToDosCount achieved';
  Color get subtitleColor => totalToDosCount == 0 ? AppColors.TEXT_BLACK_LIGHT : AppColors.PRIMARY;
  DateTime get date => DateTime(year, month, day);

  String get thumbnailString {
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

  const DayRecord({
    this.year = 0,
    this.month = 0,
    this.day = 0,
    this.weekday = 0,
    this.toDos = const [],
    this.isLocked = false,
    this.isToday = false,
  });

  DayRecord buildNew({
    bool isLocked,
  }) {
    return DayRecord(
      year: this.year,
      month: this.month,
      day: this.day,
      weekday: this.weekday,
      toDos: this.toDos,
      isLocked: isLocked ?? this.isLocked,
      isToday: this.isToday,
    );
  }
}