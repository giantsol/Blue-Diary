
import 'package:todo_app/data/AppDatabase.dart';

class ToDo {
  static String createWhereQueryForToDos() => '${AppDatabase.COLUMN_YEAR} = ?'
    ' AND ${AppDatabase.COLUMN_MONTH} = ?'
    ' AND ${AppDatabase.COLUMN_DAY} = ?';

  static String createWhereQueryForToDo() => '${AppDatabase.COLUMN_YEAR} = ?'
    ' AND ${AppDatabase.COLUMN_MONTH} = ?'
    ' AND ${AppDatabase.COLUMN_DAY} = ?'
    ' AND ${AppDatabase.COLUMN_ORDER} = ?';

  static String createWhereQueryForCategory() => '${AppDatabase.COLUMN_TODO_KEY} = ?';

  static List<dynamic> createWhereArgsForToDos(DateTime date) => [
    date.year,
    date.month,
    date.day,
  ];

  static List<dynamic> createWhereArgsForToDo(ToDo toDo) => [
    toDo.year,
    toDo.month,
    toDo.day,
    toDo.order,
  ];

  static List<dynamic> createWhereArgsForCategory(ToDo toDo) => [
    toDo.key,
  ];

  static ToDo fromDatabase(Map<String, dynamic> map) {
    return ToDo(
      year: map[AppDatabase.COLUMN_YEAR] ?? 0,
      month: map[AppDatabase.COLUMN_MONTH] ?? 0,
      day: map[AppDatabase.COLUMN_DAY] ?? 0,
      order: map[AppDatabase.COLUMN_ORDER] ?? 0,
      text: map[AppDatabase.COLUMN_TEXT] ?? '',
      isDone: (map[AppDatabase.COLUMN_DONE] ?? 0) == 1,
    );
  }

  final int year;
  final int month;
  final int day;
  final int order;
  final String text;
  final bool isDone;

  String get key => '$year-$month-$day-$order';

  const ToDo({
    this.year = 0,
    this.month = 0,
    this.day = 0,
    this.order = 0,
    this.text = '',
    this.isDone = false,
  });

  ToDo buildNew({
    int year,
    int month,
    int day,
    int order,
    String text,
    bool isDone,
  }) {
    return ToDo(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      order: order ?? this.order,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      AppDatabase.COLUMN_YEAR: year,
      AppDatabase.COLUMN_MONTH: month,
      AppDatabase.COLUMN_DAY: day,
      AppDatabase.COLUMN_ORDER: order,
      AppDatabase.COLUMN_TEXT: text,
      AppDatabase.COLUMN_DONE: isDone ? 1 : 0,
    };
  }
}