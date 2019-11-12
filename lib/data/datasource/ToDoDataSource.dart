
import 'package:todo_app/domain/entity/ToDo.dart';

abstract class ToDoDataSource {
  Future<List<ToDo>> getToDos(DateTime date);
  Future<void> setToDo(ToDo toDo);
  Future<void> removeToDo(ToDo toDo);
  Future<void> setDayMarkedCompleted(DateTime date);
  Future<int> getMarkedCompletedDaysCount();
  Future<int> getLatestStreakCount();
  Future<int> getMaxStreakCount();
  Future<int> getStreakCount(DateTime date);
  Future<bool> hasDayBeenMarkedCompleted(DateTime date);
  Future<int> getLastMarkedCompletedDayMillis(int maxMillis);
}