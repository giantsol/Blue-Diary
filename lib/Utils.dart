

import 'package:flutter/material.dart';

class Utils {

  static bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  static List<DateTime> getDatesInWeek(DateTime date) {
    final List<DateTime> datesInWeek = [];
    final mondayOfWeek = date.subtract(Duration(days: date.weekday - DateTime.monday));
    for (int i = 0; i < 7; i++) {
      datesInWeek.add(mondayOfWeek.add(Duration(days: i)));
    }
    return datesInWeek;
  }

  static Future<void> showBottomSheet(ScaffoldState scaffoldState,
    void Function(BuildContext context) builder, {
      void Function() onClosed,
    }) async {
    await scaffoldState.showBottomSheet(builder).closed;
    if (onClosed != null) {
      onClosed();
    }
  }

  static void showSnackBar(ScaffoldState scaffoldState, String text, Duration duration) {
    scaffoldState.showSnackBar(SnackBar(
      content: Text(text),
      duration: duration,
    ));
  }

}