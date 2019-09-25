
import 'package:todo_app/domain/entity/ToDo.dart';

abstract class ToDoRepository {
  Future<List<ToDo>> getToDos(DateTime date);
  void saveToDo(ToDo toDo);
  void removeToDo(ToDo toDo);
}