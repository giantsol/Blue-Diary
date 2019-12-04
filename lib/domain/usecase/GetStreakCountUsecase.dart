
import 'package:todo_app/presentation/App.dart';

class GetStreakCountUsecase {
  final _toDoRepository = dependencies.toDoRepository;

  Future<int> invoke(DateTime date) {
    return _toDoRepository.getStreakCount(date);
  }
}