
import 'package:todo_app/domain/entity/ToDo.dart';

abstract class ToDoDataSource {
  Future<List<ToDo>> getToDos(DateTime date);
  void setToDo(ToDo toDo);
  void removeToDo(ToDo toDo);
}