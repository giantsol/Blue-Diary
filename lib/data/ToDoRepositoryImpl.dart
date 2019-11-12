
import 'package:todo_app/data/datasource/ToDoDataSource.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class ToDoRepositoryImpl implements ToDoRepository {
  final ToDoDataSource _dataSource;

  const ToDoRepositoryImpl(this._dataSource);

  @override
  Future<List<ToDo>> getToDos(DateTime date) {
    return _dataSource.getToDos(date);
  }

  @override
  void setToDo(ToDo toDo) {
    _dataSource.setToDo(toDo);
  }

  @override
  void removeToDo(ToDo toDo) {
    _dataSource.removeToDo(toDo);
  }

  @override
  void setDayMarkedCompleted(DateTime date) {
    _dataSource.setDayMarkedCompleted(date);
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
  Future<int> getMaxStreakCount() {
    return _dataSource.getMaxStreakCount();
  }

  @override
  Future<int> getStreakCount(DateTime date) {
    return _dataSource.getStreakCount(date);
  }

  @override
  Future<bool> hasDayBeenMarkedCompleted(DateTime date) {
    return _dataSource.hasDayBeenMarkedCompleted(date);
  }
}