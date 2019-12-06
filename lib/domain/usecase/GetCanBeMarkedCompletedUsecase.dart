
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/domain/usecase/IsDayMarkedCompletedUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class CanDayBeMarkedCompletedUsecase {
  final _toDoRepository = dependencies.toDoRepository;
  final _prefsRepository = dependencies.prefsRepository;

  final _getTodayUsecase = GetTodayUsecase();
  final _isDayMarkedCompletedUsecase = IsDayMarkedCompletedUsecase();

  Future<bool> invoke(DateTime date) async {
    final toDos = await _toDoRepository.getToDos(date);
    final allToDosDone = toDos.length > 0 && toDos.every((it) => it.isDone);
    final hasBeenMarkedCompleted = await _isDayMarkedCompletedUsecase.invoke(date);
    final firstLaunchDate = DateTime.parse(await _prefsRepository.getFirstLaunchDateString());
    final today = await _getTodayUsecase.invoke();
    return allToDosDone && !hasBeenMarkedCompleted && date.compareTo(firstLaunchDate) >= 0 && date.compareTo(today) <= 0;
  }
}