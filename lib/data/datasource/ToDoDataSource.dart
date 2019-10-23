
import 'package:todo_app/domain/entity/ToDo.dart';

abstract class ToDoDataSource {
  Future<List<ToDo>> getToDos(DateTime date);
  Future<void> setToDo(ToDo toDo);
  Future<void> removeToDo(ToDo toDo);
}