
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class IsDayMarkedCompletedUsecase {
  final ToDoRepository _toDoRepository;

  IsDayMarkedCompletedUsecase(this._toDoRepository);

  Future<bool> invoke(DateTime date) {
    return _toDoRepository.isDayMarkedCompleted(date);
  }
}