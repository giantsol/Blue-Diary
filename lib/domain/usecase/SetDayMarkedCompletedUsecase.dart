
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class SetDayMarkedCompletedUsecase {
  ToDoRepository _toDoRepository;

  SetDayMarkedCompletedUsecase(this._toDoRepository);

  Future<void> invoke(DateTime date) {
    return _toDoRepository.setDayMarkedCompleted(date);
  }
}