
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/domain/usecase/IsDayMarkedCompletedUsecase.dart';

class GetCanBeMarkedCompletedUsecase {
  final ToDoRepository _toDoRepository;
  final PrefsRepository _prefsRepository;

  final GetTodayUsecase _getTodayUsecase;
  final IsDayMarkedCompletedUsecase _isDayMarkedCompletedUsecase;

  GetCanBeMarkedCompletedUsecase(this._toDoRepository, this._prefsRepository, DateRepository dateRepository)
    : _getTodayUsecase = GetTodayUsecase(dateRepository, _prefsRepository),
      _isDayMarkedCompletedUsecase = IsDayMarkedCompletedUsecase(_toDoRepository);

  Future<bool> invoke(DateTime date) async {
    final toDos = await _toDoRepository.getToDos(date);
    final allToDosDone = toDos.length > 0 && toDos.every((it) => it.isDone);
    final hasBeenMarkedCompleted = await _isDayMarkedCompletedUsecase.invoke(date);
    final firstLaunchDate = DateTime.parse(await _prefsRepository.getFirstLaunchDateString());
    final today = await _getTodayUsecase.invoke();
    return allToDosDone && !hasBeenMarkedCompleted && date.compareTo(firstLaunchDate) >= 0 && date.compareTo(today) <= 0;
  }
}