
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/ToDo.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemo.dart';

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

  Future<DayRecord> loadDayRecord(DateTime dateTime) async {
    final Database db = await _database.first;
    // 하나의 DayRecord를 만들기 위해서는 ToDo들과 DayMemo가 필요함

    // get ToDos
    var dateString = ToDo.dateTimeToDateString(dateTime);
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'date_string = ?',
      whereArgs: [dateString],
    );
    final List<ToDo> todos = List.generate(maps.length, (i) {
      final map = maps[i];
      return ToDo(
        dateTime,
        map['which'],
        content: map['content'],
        isDone: map['done'] == 1 ? true : false,
      );
    });

    // get DayMemo
    dateString = DayMemo.dateTimeToDateString(dateTime);
    final Map<String, dynamic> map = await db.query(
      'day_memos',
      where: 'date_string = ?',
      whereArgs: [dateString],
    ).then((l) => l.isEmpty ? null : l[0]);
    final DayMemo dayMemo = map == null ? DayMemo(dateTime, '') : DayMemo(
      dateTime,
      map['content'],
    );

    return DayRecord(dateTime, todos, dayMemo);
  }

  saveDayMemo(DayMemo dayMemo) async {
    final Database db = await _database.first;
    await db.insert(
      'day_memos',
      dayMemo.toDatabaseFormat(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
      weekMemos[index] = weekMemos[index].getModified(content: map['content']);
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

}