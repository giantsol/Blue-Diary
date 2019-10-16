
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';

class BottomNavigationItem {
  static const KEY_RECORD = 'record';
  static const KEY_SETTINGS = 'settings';

  final String key;
  final String iconPath;
  final Color titleColor;

  const BottomNavigationItem({
    this.key = '',
    this.iconPath = '',
    this.titleColor = AppColors.TEXT_BLACK_LIGHT,
  });
}