
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class SetToDoUsecase {
  final ToDoRepository _toDoRepository;

  SetToDoUsecase(this._toDoRepository);

  Future<void> invoke(ToDo toDo) {
    return _toDoRepository.setToDo(toDo);
  }
}