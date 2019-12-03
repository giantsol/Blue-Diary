
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';

class GetCompletionRatioUsecase {
  final PrefsRepository _prefsRepository;
  final ToDoRepository _toDoRepository;

  final GetTodayUsecase _getTodayUsecase;

  GetCompletionRatioUsecase(this._prefsRepository, this._toDoRepository, DateRepository dateRepository)
    : _getTodayUsecase = GetTodayUsecase(dateRepository);

  Future<double> invoke() async {
    final firstLaunchDateString = await _prefsRepository.getFirstLaunchDateString();
    if (firstLaunchDateString.isEmpty) {
      return 0;
    } else {
      final today = await _getTodayUsecase.invoke();
      final firstLaunchDate = DateTime.parse(firstLaunchDateString);

      final totalDaysCount = today.difference(firstLaunchDate).inDays + 1;
      final markedCompletedDaysCount = await _toDoRepository.getMarkedCompletedDaysCount();

      if (totalDaysCount <= 0) {
        return 0;
      } else {
        return markedCompletedDaysCount / totalDaysCount;
      }
    }
  }
}