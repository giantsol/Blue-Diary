import 'package:todo_app/data/AppDatabase.dart';

class DayMemo {
  static String createWhereQuery() => '${AppDatabase.COLUMN_YEAR} = ?'
    ' AND ${AppDatabase.COLUMN_MONTH} = ?'
    ' AND ${AppDatabase.COLUMN_DAY} = ?';

  static List<dynamic> createWhereArgs(DateTime date) => [
    date.year,
    date.month,
    date.day,
  ];

  static DayMemo fromDatabase(Map<String, dynamic> map) {
    return DayMemo(
      year: map[AppDatabase.COLUMN_YEAR] ?? 0,
      month: map[AppDatabase.COLUMN_MONTH] ?? 0,
      day: map[AppDatabase.COLUMN_DAY] ?? 0,
      text: map[AppDatabase.COLUMN_TEXT] ?? '',
    );
  }

  final int year;
  final int month;
  final int day;
  final String text;

  const DayMemo({
    this.year = 0,
    this.month = 0,
    this.day = 0,
    this.text = '',
  });

  DayMemo buildNew({
    int year,
    int month,
    int day,
    String text,
  }) {
    return DayMemo(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      AppDatabase.COLUMN_YEAR: year,
      AppDatabase.COLUMN_MONTH: month,
      AppDatabase.COLUMN_DAY: day,
      AppDatabase.COLUMN_TEXT: text,
    };
  }
}