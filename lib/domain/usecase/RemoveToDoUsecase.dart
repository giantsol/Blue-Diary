
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class RemoveToDoUsecase {
  final ToDoRepository _toDoRepository;

  RemoveToDoUsecase(this._toDoRepository);

  void invoke(ToDo toDo) {
    _toDoRepository.removeToDo(toDo);
  }
}