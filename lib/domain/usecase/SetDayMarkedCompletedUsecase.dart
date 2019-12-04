
import 'package:todo_app/presentation/App.dart';

class SetDayMarkedCompletedUsecase {
  final _toDoRepository = dependencies.toDoRepository;

  Future<void> invoke(DateTime date) {
    return _toDoRepository.setDayMarkedCompleted(date);
  }
}