
import 'package:todo_app/data/AppDatabase.dart';

class ToDo {
  static String createWhereQueryForToDos() => '${AppDatabase.COLUMN_YEAR} = ?'
    ' AND ${AppDatabase.COLUMN_MONTH} = ?'
    ' AND ${AppDatabase.COLUMN_DAY} = ?';

  static String createWhereQueryForToDo() => '${AppDatabase.COLUMN_YEAR} = ?'
    ' AND ${AppDatabase.COLUMN_MONTH} = ?'
    ' AND ${AppDatabase.COLUMN_DAY} = ?'
    ' AND ${AppDatabase.COLUMN_INDEX} = ?';

  static List<dynamic> createWhereArgsForToDos(DateTime date) => [
    date.year,
    date.month,
    date.day,
  ];

  static List<dynamic> createWhereArgsForToDo(ToDo toDo) => [
    toDo.year,
    toDo.month,
    toDo.day,
    toDo.index,
  ];

  static ToDo fromDatabase(Map<String, dynamic> map) {
    return ToDo(
      year: map[AppDatabase.COLUMN_YEAR] ?? 0,
      month: map[AppDatabase.COLUMN_MONTH] ?? 0,
      day: map[AppDatabase.COLUMN_DAY] ?? 0,
      index: map[AppDatabase.COLUMN_INDEX] ?? 0,
      text: map[AppDatabase.COLUMN_TEXT] ?? '',
      isDone: (map[AppDatabase.COLUMN_DONE] ?? 0) == 1,
    );
  }

  final int year;
  final int month;
  final int day;
  final int index;
  final String text;
  final bool isDone;

  const ToDo({
    this.year = 0,
    this.month = 0,
    this.day = 0,
    this.index = 0,
    this.text = '',
    this.isDone = false,
  });

  ToDo buildNew({
    int year,
    int month,
    int day,
    int index,
    String text,
    bool isDone,
  }) {
    return ToDo(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      index: index ?? this.index,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      AppDatabase.COLUMN_YEAR: year,
      AppDatabase.COLUMN_MONTH: month,
      AppDatabase.COLUMN_DAY: day,
      AppDatabase.COLUMN_INDEX: index,
      AppDatabase.COLUMN_TEXT: text,
      AppDatabase.COLUMN_DONE: isDone ? 1 : 0,
    };
  }
}