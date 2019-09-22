
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';

class DayPreview {
  final String thumbnailString;
  final String title;
  final int totalToDosCount;
  final int doneToDosCount;
  final bool isLocked;
  final bool hasTrailingDots;

  bool get hasBorder => totalToDosCount > 0;
  double get filledRatio => totalToDosCount == 0 ? 0 : doneToDosCount / totalToDosCount.toDouble();
  String get subtitle => totalToDosCount == 0 ? 'No Todos' : '$doneToDosCount/$totalToDosCount achieved';
  Color get subtitleColor => totalToDosCount == 0 ? AppColors.textBlackLight : AppColors.primary;

  const DayPreview({
    this.thumbnailString,
    this.title,
    this.totalToDosCount,
    this.doneToDosCount,
    this.isLocked,
    this.hasTrailingDots,
  });
}