
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/ToDo.dart';

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
    final dateString = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'date_string = ?',
      whereArgs: [dateString],
    );
    final List<ToDo> todos = List.generate(maps.length, (i) {
      final map = maps[i];
      return ToDo(
        map['date_string'],
        map['which'],
        content: map['content'],
        isDone: map['done'] == 1 ? true : false,
      );
    });

    final Map<String, dynamic> map = await db.query(
      'day_memos',
      where: 'date_string = ?',
      whereArgs: [dateString],
    ).then((l) => l.isEmpty ? null : l[0]);
    final DayMemo dayMemo = map == null ? DayMemo(dateString, '') : DayMemo(
      map['date_string'],
      map['content'],
    );

    return DayRecord(dateTime, todos, dayMemo);
  }

  Future<void> saveDayMemo(DayMemo dayMemo) async {
    final Database db = await _database.first;
    await db.insert(
      'day_memos',
      dayMemo.toDatabaseFormat(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}