
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/presentation/App.dart';

class SetToDoUsecase {
  final _toDoRepository = dependencies.toDoRepository;

  Future<void> invoke(ToDo toDo) {
    return _toDoRepository.setToDo(toDo);
  }
}