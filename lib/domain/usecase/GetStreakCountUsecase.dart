
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class GetStreakCountUsecase {
  final ToDoRepository _toDoRepository;

  GetStreakCountUsecase(this._toDoRepository);

  Future<int> invoke(DateTime date) {
    return _toDoRepository.getStreakCount(date);
  }
}