
import 'package:todo_app/data/datasource/ToDoDataSource.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class ToDoRepositoryImpl implements ToDoRepository {
  final ToDoDataSource _dataSource;

  const ToDoRepositoryImpl(this._dataSource);

  @override
  Future<List<ToDo>> getToDos(DateTime date) {
    return _dataSource.getToDos(date);
  }

  @override
  Future<void> setToDo(ToDo toDo) {
    return _dataSource.setToDo(toDo);
  }

  @override
  void removeToDo(ToDo toDo) {
    _dataSource.removeToDo(toDo);
  }

  @override
  Future<void> setDayMarkedCompleted(DateTime date) {
    return _dataSource.setDayMarkedCompleted(date);
  }

  @override
  Future<int> getMarkedCompletedDaysCount() {
    return _dataSource.getMarkedCompletedDaysCount();
  }

  @override
  Future<int> getLatestStreakCount() {
    return _dataSource.getLatestStreakCount();
  }

  @override
  Future<int> getLatestStreakEndMillis() {
    return _dataSource.getLatestStreakEndMillis();
  }

  @override
  Future<int> getLongestStreakCount() {
    return _dataSource.getLongestStreakCount();
  }

  @override
  Future<int> getLongestStreakEndMillis() {
    return _dataSource.getLongestStreakEndMillis();
  }

  @override
  Future<int> getStreakCount(DateTime date) {
    return _dataSource.getStreakCount(date);
  }

  @override
  Future<bool> isDayMarkedCompleted(DateTime date) {
    return _dataSource.isDayMarkedCompleted(date);
  }

  @override
  Future<DateTime> getLastMarkedCompletedDay(int maxMillis) async {
    final millis =  await _dataSource.getLastMarkedCompletedDayMillis(maxMillis);
    if (millis <= 0) {
      return DateRepository.INVALID_DATE;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
  }
}