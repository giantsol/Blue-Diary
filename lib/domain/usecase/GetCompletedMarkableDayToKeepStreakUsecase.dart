
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/GetCanBeMarkedCompletedUsecase.dart';

class GetCompletedMarkableDayToKeepStreakUsecase {

  final GetCanBeMarkedCompletedUsecase _getCanBeMarkedCompletedUsecase;

  GetCompletedMarkableDayToKeepStreakUsecase(ToDoRepository toDoRepository, PrefsRepository prefsRepository, DateRepository dateRepository)
    : _getCanBeMarkedCompletedUsecase = GetCanBeMarkedCompletedUsecase(toDoRepository, prefsRepository, dateRepository);

  Future<DateTime> invoke(DateTime date) async {
    final prevDay = date.subtract(const Duration(days: 1));
    final canPrevDayBeMarkedCompleted = await _getCanBeMarkedCompletedUsecase.invoke(prevDay);
    if (canPrevDayBeMarkedCompleted) {
      return prevDay;
    } else {
      return DateRepository.INVALID_DATE;
    }
  }
}