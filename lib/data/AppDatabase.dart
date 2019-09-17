
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';

class AppDatabase {
  final _database = BehaviorSubject<Database>();

  AppDatabase() {
    _initDatabase();
  }

  _initDatabase() async {
    _database.value = await openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
          """
          CREATE TABLE week_memos(
            date_string TEXT NOT NULL,
            which INTEGER NOT NULL,
            content TEXT,
            PRIMARY KEY (date_string, which)
          );
          """
        );
        await db.execute(
          """
          CREATE TABLE todos(
            date_string TEXT NOT NULL,
            which INTEGER NOT NULL,
            content TEXT,
            done INTEGER,
            PRIMARY KEY (date_string, which)
          );
          """
        );
        return db.execute(
          """
          CREATE TABLE day_memos(
            date_string TEXT NOT NULL PRIMARY KEY,
            content TEXT
          );
          """
        );
      },
      version: 1,
    );
  }

  Future<List<ToDo>> loadToDos(DateTime date) async {
    final db = await _database.first;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'date_string = ?',
      whereArgs: [ToDo.dateTimeToDateString(date)],
    );
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return ToDo(
        date,
        map['which'],
        content: map['content'],
        isDone: map['done'] == 1 ? true : false,
      );
    });
  }

  saveDayMemo(DayMemo dayMemo) async {
    final db = await _database.first;
    await db.insert(
      'day_memos',
      dayMemo.toDatabaseFormat(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DayMemo> loadDayMemo(DateTime date) async {
    final db = await _database.first;
    final Map<String, dynamic> map = await db.query(
      'day_memos',
      where: 'date_string = ?',
      whereArgs: [DayMemo.dateTimeToDateString(date)],
    ).then((l) => l.isEmpty ? null : l[0]);
    final content = map != null ? map['content'] : '';
    return DayMemo(date, content);
  }

  Future<List<WeekMemo>> loadWeekMemos(DateTime dateTime) async {
    final db = await _database.first;
    // weekMemo는 항상 3개로 고정
    final List<WeekMemo> weekMemos = [
      WeekMemo(dateTime, 0),
      WeekMemo(dateTime, 1),
      WeekMemo(dateTime, 2),
    ];
    final dateString = WeekMemo.dateTimeToDateString(dateTime);
    final List<Map<String, dynamic>> maps = await db.query(
      'week_memos',
      where: 'date_string = ?',
      whereArgs: [dateString],
    );
    maps.forEach((map) {
      final index = map['which'];
      weekMemos[index] = weekMemos[index].buildNew(content: map['content']);
    });

    return weekMemos;
  }

  saveWeekMemo(WeekMemo weekMemo) async {
    final db = await _database.first;
    await db.insert(
      'week_memos',
      weekMemo.toDatabaseFormat(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  saveToDo(ToDo toDo) async {
    final db = await _database.first;
    await db.insert(
      'todos',
      toDo.toDatabaseFormat(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  removeToDo(ToDo toDo) async {
    final db = await _database.first;
    await db.delete(
      'todos',
      where: 'date_string = ? AND which = ?',
      whereArgs: [ToDo.dateTimeToDateString(toDo.dateTime), toDo.index],
    );
  }

}