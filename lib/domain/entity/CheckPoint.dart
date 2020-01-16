
import 'package:todo_app/data/datasource/AppDatabase.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';

class CheckPoint {
  static String createWhereQueryForCheckPoints() => '${AppDatabase.COLUMN_YEAR} = ?'
    ' AND ${AppDatabase.COLUMN_MONTH} = ?'
    ' AND ${AppDatabase.COLUMN_NTH_WEEK} = ?';

  static List<dynamic> createWhereArgsForCheckPoints(DateInWeek dateInWeek) => [
    dateInWeek.year,
    dateInWeek.month,
    dateInWeek.nthWeek,
  ];

  final int year;
  final int month;
  final int nthWeek;
  final int index;
  final String text;
  final String hint;

  String get key => '$year-$month-$nthWeek-$index';

  const CheckPoint({
    this.year = 0,
    this.month = 0,
    this.nthWeek = 0,
    this.index = 0,
    this.text = '',
    this.hint = '',
  });

  CheckPoint buildNew({
    int year,
    int month,
    int nthWeek,
    int index,
    String text,
    String hint,
  }) {
    return CheckPoint(
      year: year ?? this.year,
      month: month ?? this.month,
      nthWeek: nthWeek ?? this.nthWeek,
      index: index ?? this.index,
      text: text ?? this.text,
      hint: hint ?? this.hint,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      AppDatabase.COLUMN_YEAR: year,
      AppDatabase.COLUMN_MONTH: month,
      AppDatabase.COLUMN_NTH_WEEK: nthWeek,
      AppDatabase.COLUMN_INDEX: index,
      AppDatabase.COLUMN_TEXT: text,
      AppDatabase.COLUMN_HINT: '',
    };
  }
}