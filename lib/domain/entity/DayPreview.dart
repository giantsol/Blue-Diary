
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
  final bool isLightColor;
  final bool isTopLineVisible;
  final bool isTopLineLightColor;
  final bool isBottomLineVisible;
  final bool isBottomLineLightColor;
  final String memoPreview;
  final List<ToDo> toDoPreviews;

  bool get hasTrailingDots => weekday != DateTime.sunday;
  String get key => '$year-$month-$day';
  bool get hasBorder => totalToDosCount > 0;
  double get ratio => totalToDosCount == 0 ? 0 : doneToDosCount / totalToDosCount.toDouble();
  String get subtitle => totalToDosCount == 0 ? 'No TODO' : '$doneToDosCount/$totalToDosCount achieved';
  Color get subtitleColor => totalToDosCount == 0 ? AppColors.TEXT_BLACK_LIGHT : AppColors.PRIMARY;
  DateTime get date => DateTime(year, month, day);

  String get thumbnailString {
    if (totalToDosCount == 0) {
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
    this.memoPreview = '-',
    this.toDoPreviews = const [],
  });

  DayPreview buildNew({
    bool isBottomLineVisible,
    bool isBottomLineLightColor,
  }) {
    return DayPreview(
      year: this.year,
      month: this.month,
      day: this.day,
      weekday: this.weekday,
      totalToDosCount: this.totalToDosCount,
      doneToDosCount: this.doneToDosCount,
      isToday: this.isToday,
      isLightColor: this.isLightColor,
      isTopLineVisible: this.isTopLineVisible,
      isTopLineLightColor: this.isTopLineLightColor,
      isBottomLineVisible: isBottomLineVisible ?? this.isBottomLineVisible,
      isBottomLineLightColor: isBottomLineLightColor ?? this.isBottomLineLightColor,
      memoPreview: this.memoPreview,
      toDoPreviews: this.toDoPreviews,
    );
  }
}