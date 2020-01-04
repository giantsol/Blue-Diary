
import 'package:todo_app/data/datasource/AppDatabase.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class ToDoRepositoryImpl implements ToDoRepository {
  final AppDatabase _database;

  const ToDoRepositoryImpl(this._database);

  @override
  Future<List<ToDo>> getToDos(DateTime date) {
    return _database.getToDos(date);
  }

  @override
  Future<void> setToDo(ToDo toDo) {
    return _database.setToDo(toDo);
  }

  @override
  Future<void> removeToDo(ToDo toDo) {
    return _database.removeToDo(toDo);
  }

  @override
  Future<void> setDayMarkedCompleted(DateTime date) {
    return _database.setDayMarkedCompleted(date);
  }

  @override
  Future<int> getMarkedCompletedDaysCount() {
    return _database.getMarkedCompletedDaysCount();
  }

  @override
  Future<int> getLatestStreakCount() {
    return _database.getLatestStreakCount();
  }

  @override
  Future<int> getLatestStreakEndMillis() {
    return _database.getLatestStreakEndMillis();
  }

  @override
  Future<int> getLongestStreakCount() {
    return _database.getLongestStreakCount();
  }

  @override
  Future<int> getLongestStreakEndMillis() {
    return _database.getLongestStreakEndMillis();
  }

  @override
  Future<int> getStreakCount(DateTime date) {
    return _database.getStreakCount(date);
  }

  @override
  Future<bool> isDayMarkedCompleted(DateTime date) {
    return _database.isDayMarkedCompleted(date);
  }

  @override
  Future<DateTime> getLastMarkedCompletedDay(int maxMillis) async {
    final millis =  await _database.getLastMarkedCompletedDayMillis(maxMillis);
    if (millis <= 0) {
      return DateRepository.INVALID_DATE;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
  }
}