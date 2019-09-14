
import 'package:todo_app/domain/entity/ToDo.dart';

abstract class ToDoRepository {

  Future<List<ToDo>> getToDos(DateTime date);
  saveToDo(ToDo toDo);
  removeToDo(ToDo toDo);

}