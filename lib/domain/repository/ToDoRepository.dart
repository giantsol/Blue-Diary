
import 'package:todo_app/domain/entity/ToDo.dart';

abstract class ToDoRepository {
  Future<List<ToDo>> getToDos(DateTime date);
  Future<void> setToDo(ToDo toDo);
  void removeToDo(ToDo toDo);
  Future<void> setDayMarkedCompleted(DateTime date);
  Future<int> getMarkedCompletedDaysCount();
  Future<int> getLatestStreakCount();
  Future<int> getLatestStreakEndMillis();
  Future<int> getLongestStreakCount();
  Future<int> getLongestStreakEndMillis();
  Future<int> getStreakCount(DateTime date);
  Future<bool> isDayMarkedCompleted(DateTime date);
  Future<DateTime> getLastMarkedCompletedDay(int maxMillis);
}