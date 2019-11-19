
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class DayPreview {
  final int year;
  final int month;
  final int day;
  final int weekday;
  final int totalToDosCount;
  final int doneToDosCount;
  final bool isToday;
  // whether its color should be weakened(i.e. light)
  final bool isLightColor;
  final bool isTopLineVisible;
  final bool isTopLineLightColor;
  final bool isBottomLineVisible;
  final bool isBottomLineLightColor;
  final String memoPreview;
  final List<ToDo> toDoPreviews;
  final bool canBeMarkedCompleted;
  final bool isMarkedCompleted;
  final int streakCount;

  bool get hasTrailingDots => weekday != DateTime.sunday;
  String get key => '$year-$month-$day';
  bool get hasBorder => totalToDosCount > 0;
  double get ratio => totalToDosCount == 0 ? 0 : doneToDosCount / totalToDosCount.toDouble();
  String get subtitle => totalToDosCount == 0 ? 'No TODO' : '$doneToDosCount/$totalToDosCount achieved';
  Color get subtitleColor => totalToDosCount == 0 ? AppColors.TEXT_BLACK_LIGHT : AppColors.PRIMARY;
  DateTime get date => DateTime(year, month, day);

  String get thumbnailString {
    if (isMarkedCompleted) {
      return '$streakCount';
    } else if (totalToDosCount == 0) {
      return '-';
    } else {
      final percent = (ratio * 100).toInt();
      return '$percent%';
    }
  }

  const DayPreview({
    this.year = 0,
    this.month = 0,
    this.day = 0,
    this.weekday = 0,
    this.totalToDosCount = 0,
    this.doneToDosCount = 0,
    this.isToday = false,
    this.isLightColor = false,
    this.isTopLineVisible = false,
    this.isTopLineLightColor = false,
    this.isBottomLineVisible = false,
    this.isBottomLineLightColor = false,
    this.memoPreview = '',
    this.toDoPreviews = const [],
    this.canBeMarkedCompleted = false,
    this.isMarkedCompleted = false,
    this.streakCount = 0,
  });
}