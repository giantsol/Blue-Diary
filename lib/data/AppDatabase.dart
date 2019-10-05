
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/Lock.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class AppDatabase {
  static const String TABLE_CHECK_POINTS = 'checkpoints';
  static const String TABLE_TODOS = 'todos';
  static const String TABLE_LOCKS = 'locks';
  static const String TABLE_DAY_MEMOS = 'daymemos';
  static const String TABLE_CATEGORIES = 'categories';

  static const String COLUMN_ID = '_id';
  static const String COLUMN_YEAR = 'year';
  static const String COLUMN_MONTH = 'month';
  static const String COLUMN_DAY = 'day';
  static const String COLUMN_NTH_WEEK = 'nth_week';
  static const String COLUMN_INDEX = '_index';
  static const String COLUMN_ORDER = '_order';
  static const String COLUMN_TEXT = 'text';
  static const String COLUMN_HINT = 'hint';
  static const String COLUMN_DONE = 'done';
  static const String COLUMN_KEY = '_key';
  static const String COLUMN_LOCKED = 'locked';
  static const String COLUMN_EXPANDED = 'expanded';
  static const String COLUMN_NAME = 'name';
  static const String COLUMN_FILL_COLOR = 'fill_color';
  static const String COLUMN_BORDER_COLOR = 'border_color';
  static const String COLUMN_IMAGE_PATH = 'image_path';
  static const String COLUMN_CATEGORY_ID = 'category_id';

  final _database = BehaviorSubject<Database>();

  AppDatabase() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'todo5.db');
    _database.value = await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute(
          """
          CREATE TABLE $TABLE_CHECK_POINTS(
            $COLUMN_YEAR INTEGER NOT NULL,
            $COLUMN_MONTH INTEGER NOT NULL,
            $COLUMN_NTH_WEEK INTEGER NOT NULL,
            $COLUMN_INDEX INTEGER NOT NULL,
            $COLUMN_TEXT TEXT NOT NULL,
            $COLUMN_HINT TEXT NOT NULL,
            PRIMARY KEY ($COLUMN_YEAR, $COLUMN_MONTH, $COLUMN_NTH_WEEK, $COLUMN_INDEX)
          );
          """
        );
        await db.execute(
          """
          CREATE TABLE $TABLE_TODOS(
            $COLUMN_YEAR INTEGER NOT NULL,
            $COLUMN_MONTH INTEGER NOT NULL,
            $COLUMN_DAY INTEGER NOT NULL,
            $COLUMN_ORDER INTEGER NOT NULL,
            $COLUMN_TEXT TEXT NOT NULL,
            $COLUMN_DONE INTEGER NOT NULL,
            $COLUMN_CATEGORY_ID INTEGER NOT NULL,
            PRIMARY KEY ($COLUMN_YEAR, $COLUMN_MONTH, $COLUMN_DAY, $COLUMN_ORDER)
          );
          """
        );
        await db.execute(
          """
          CREATE TABLE $TABLE_LOCKS(
            $COLUMN_KEY TEXT NOT NULL PRIMARY KEY,
            $COLUMN_LOCKED INTEGER NOT NULL
          );
          """
        );
        await db.execute(
          """
          CREATE TABLE $TABLE_CATEGORIES(
            $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_NAME TEXT NOT NULL,
            $COLUMN_FILL_COLOR INTEGER NOT NULL,
            $COLUMN_BORDER_COLOR INTEGER NOT NULL,
            $COLUMN_IMAGE_PATH TEXT NOT NULL
          );
          """
        );
        return db.execute(
          """
          CREATE TABLE $TABLE_DAY_MEMOS(
            $COLUMN_YEAR INTEGER NOT NULL,
            $COLUMN_MONTH INTEGER NOT NULL,
            $COLUMN_DAY INTEGER NOT NULL,
            $COLUMN_TEXT TEXT NOT NULL,
            $COLUMN_HINT TEXT NOT NULL,
            $COLUMN_EXPANDED INTEGER NOT NULL,
            PRIMARY KEY ($COLUMN_YEAR, $COLUMN_MONTH, $COLUMN_DAY)
          );
          """
        );
      },
      version: 1,
    );
  }

  Future<List<ToDo>> getToDos(DateTime date) async {
    final db = await _database.first;
    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_TODOS,
      where: ToDo.createWhereQueryForToDos(),
      whereArgs: ToDo.createWhereArgsForToDos(date),
    );
    final List<ToDo> result = [];
    for (int i = 0; i < maps.length; i++) {
      final toDo = ToDo.fromDatabase(maps[i]);
      result.add(toDo);
    }
    result.sort((a, b) => a.order - b.order);
    return result;
  }

  Future<void> setDayMemo(DayMemo dayMemo) async {
    final db = await _database.first;
    await db.insert(
      TABLE_DAY_MEMOS,
      dayMemo.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DayMemo> getDayMemo(DateTime date) async {
    final db = await _database.first;
    final Map<String, dynamic> map = await db.query(
      TABLE_DAY_MEMOS,
      where: DayMemo.createWhereQuery(),
      whereArgs: DayMemo.createWhereArgs(date),
    ).then((l) => l.isEmpty ? null : l[0]);
    return map != null ? DayMemo.fromDatabase(map)
      : DayMemo(year: date.year, month: date.month, day: date.day);
  }

  Future<List<CheckPoint>> getCheckPoints(DateTime date) async {
    final db = await _database.first;
    final dateInWeek = DateInWeek.fromDate(date);
    final List<CheckPoint> checkPoints = [
      CheckPoint(year: dateInWeek.year, month: dateInWeek.month, nthWeek: dateInWeek.nthWeek, index: 0),
      CheckPoint(year: dateInWeek.year, month: dateInWeek.month, nthWeek: dateInWeek.nthWeek, index: 1),
      CheckPoint(year: dateInWeek.year, month: dateInWeek.month, nthWeek: dateInWeek.nthWeek, index: 2),
    ];
    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_CHECK_POINTS,
      where: CheckPoint.createWhereQueryForCheckPoints(),
      whereArgs: CheckPoint.createWhereArgsForCheckPoints(dateInWeek),
    );
    maps.forEach((map) {
      final index = map[COLUMN_INDEX];
      checkPoints[index] = checkPoints[index].buildNew(text: map[COLUMN_TEXT], hint: map[COLUMN_HINT]);
    });

    return checkPoints;
  }

  Future<bool> getIsCheckPointsLocked(DateTime date) async {
    final db = await _database.first;
    final Map<String, dynamic> map = await db.query(
      TABLE_LOCKS,
      where: Lock.createWhereQuery(),
      whereArgs: Lock.createWhereArgsForCheckPoints(DateInWeek.fromDate(date)),
    ).then((l) => l.isEmpty ? null : l[0]);
    return map != null ? Lock.fromDatabase(map).isLocked : false;
  }

  Future<void> setIsCheckPointsLocked(DateInWeek dateInWeek, bool value) async {
    final db = await _database.first;
    final map = {
      COLUMN_KEY: Lock.createKeyForCheckPoints(dateInWeek),
      COLUMN_LOCKED: value ? 1 : 0,
    };
    await db.insert(
      TABLE_LOCKS,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setIsDayRecordLocked(DateTime date, bool value) async {
    final db = await _database.first;
    final map = {
      COLUMN_KEY: Lock.createKeyForDayRecord(date),
      COLUMN_LOCKED: value ? 1 : 0,
    };
    await db.insert(
      TABLE_LOCKS,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setCheckPoint(CheckPoint checkPoint) async {
    final db = await _database.first;
    await db.insert(
      TABLE_CHECK_POINTS,
      checkPoint.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> getIsDayRecordLocked(DateTime date) async {
    final db = await _database.first;
    final Map<String, dynamic> map = await db.query(
      TABLE_LOCKS,
      where: Lock.createWhereQuery(),
      whereArgs: Lock.createWhereArgsForDayRecord(date),
    ).then((l) => l.isEmpty ? null : l[0]);
    return map != null ? Lock.fromDatabase(map).isLocked : false;
  }

  Future<void> setToDo(ToDo toDo) async {
    final db = await _database.first;
    await db.insert(
      TABLE_TODOS,
      toDo.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeToDo(ToDo toDo) async {
    final db = await _database.first;
    await db.delete(
      TABLE_TODOS,
      where: ToDo.createWhereQueryForToDo(),
      whereArgs: ToDo.createWhereArgsForToDo(toDo),
    );
  }

  Future<Category> getCategory(int id) async {
    final db = await _database.first;
    Map<String, dynamic> map = await db.query(
      TABLE_CATEGORIES,
      where: Category.createWhereQuery(),
      whereArgs: Category.createWhereArgs(id),
    ).then((l) => l.isEmpty ? null : l[0]);
    return map != null ? Category.fromDatabase(map) : Category();
  }

  Future<List<Category>> getAllCategories() async {
    final db = await _database.first;
    List<Map<String, dynamic>> maps = await db.query(
      TABLE_CATEGORIES
    );
    final List<Category> result = [];
    // add one default category cause we don't save it in DB
    result.add(Category());
    for (int i = 0; i < maps.length; i++) {
      final category = Category.fromDatabase(maps[i]);
      result.add(category);
    }
    result.sort((a, b) => a.id - b.id);
    return result;
  }

  Future<int> setCategory(Category category) async {
    if (category.type == CategoryType.DEFAULT) {
      return -1;
    } else {
      final db = await _database.first;
      return db.insert(
        TABLE_CATEGORIES,
        category.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}