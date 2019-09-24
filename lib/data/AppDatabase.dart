
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
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
    final dbPath = join(await getDatabasesPath(), 'todo1.db');
    _database.value = await openDatabase(
      dbPath,
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
          CREATE TABLE check_points(
            date_string TEXT NOT NULL,
            which INTEGER NOT NULL,
            content TEXT,
            content_hint TEXT,
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
        await db.execute(
          """
          CREATE TABLE locks(
            date_string TEXT NOT NULL PRIMARY KEY,
            is_locked INTEGER NOT NULL
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

  Future<List<CheckPoint>> loadCheckPoints(DateTime date) async {
    final db = await _database.first;
    final List<CheckPoint> checkPoints = [
      CheckPoint(index: 0, text: '', hintText: ''),
      CheckPoint(index: 1, text: '', hintText: ''),
      CheckPoint(index: 2, text: '', hintText: ''),
    ];
    final dateString = CheckPoint.dateToDateString(date);
    final List<Map<String, dynamic>> maps = await db.query(
      'check_points',
      where: 'date_string = ?',
      whereArgs: [dateString],
    );
    maps.forEach((map) {
      final index = map['which'];
      checkPoints[index] = checkPoints[index].buildNew(text: map['content']);
    });

    return checkPoints;
  }

  Future<bool> loadIsCheckPointsLocked(DateTime date) async {
    final db = await _database.first;
    final List<Map<String, dynamic>> maps = await db.query(
      'locks',
      where: 'date_string = ?',
      whereArgs: [_createCheckPointsLockKey(date)],
    );
    if (maps.isEmpty) {
      return false;
    } else {
      return maps[0]['is_locked'] == 1;
    }
  }

  String _createCheckPointsLockKey(DateTime date) {
    final dateInWeek = DateInWeek.fromDate(date);
    return '${dateInWeek.year}-${dateInWeek.monthAndNthWeekText}';
  }

  Future<bool> loadIsDayRecordLocked(DateTime date) async {
    final db = await _database.first;
    final List<Map<String, dynamic>> maps = await db.query(
      'locks',
      where: 'date_string = ?',
      whereArgs: [_createDayRecordLockKey(date)],
    );
    if (maps.isEmpty) {
      return false;
    } else {
      return maps[0]['is_locked'] == 1;
    }
  }

  String _createDayRecordLockKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
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