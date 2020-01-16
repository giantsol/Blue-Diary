
import 'package:todo_app/presentation/App.dart';

class IsDayMarkedCompletedUsecase {
  final _toDoRepository = dependencies.toDoRepository;

  Future<bool> invoke(DateTime date) {
    return _toDoRepository.isDayMarkedCompleted(date);
  }
}