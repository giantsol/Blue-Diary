
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class JourneyUsecases {
  final DateRepository _dateRepository;
  final PrefsRepository _prefsRepository;
  final ToDoRepository _toDoRepository;

  const JourneyUsecases(this._dateRepository, this._prefsRepository, this._toDoRepository);

  Future<double> getCompletionRatio() async {
    final firstLaunchDateString = await _prefsRepository.getFirstLaunchDateString();
    if (firstLaunchDateString.isEmpty) {
      return 0;
    } else {
      final today = await _dateRepository.getToday();
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

  Future<int> getLatestStreakCount() {
    return _toDoRepository.getLatestStreakCount();
  }

  Future<int> getMaxStreakCount() {
    return _toDoRepository.getMaxStreakCount();
  }
}