

import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';

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

  static Future<T> showAppDialog<T>(BuildContext context,
    String title, String body,
    void Function() onCancelClicked, void Function() onOkClicked) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: AppColors.TEXT_BLACK,
              fontSize: 20,
            ),
          ),
          content: Text(
            body,
            style: TextStyle(
              color: AppColors.TEXT_BLACK_LIGHT,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(
                  color: AppColors.TEXT_BLACK,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (onCancelClicked != null) {
                  onCancelClicked();
                }
              },
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).ok,
                style: TextStyle(
                  color: AppColors.PRIMARY,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (onOkClicked != null) {
                  onOkClicked();
                }
              },
            )
          ],
        );
      },
    );
  }

}