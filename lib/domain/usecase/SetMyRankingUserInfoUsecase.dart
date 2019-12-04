
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/usecase/GetSelectedPetUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class SetMyRankingUserInfoUsecase {
  final _userRepository = dependencies.userRepository;
  final _toDoRepository = dependencies.toDoRepository;
  final _rankingRepository = dependencies.rankingRepository;
  final _prefsRepository = dependencies.prefsRepository;

  final _getSelectedPetUsecase = GetSelectedPetUsecase();
  final _getTodayUsecase = GetTodayUsecase();

  Future<void> invoke() async {
    final uid = await _userRepository.getUserId();
    final firstLaunchDateString = await _prefsRepository.getFirstLaunchDateString();
    final today = await _getTodayUsecase.invoke();

    if (uid.isNotEmpty && firstLaunchDateString.isNotEmpty && today != DateRepository.INVALID_DATE) {
      final userName = await _userRepository.getUserDisplayName();

      final firstLaunchDate = DateTime.parse(firstLaunchDateString);
      final totalDaysCount = today.difference(firstLaunchDate).inDays + 1;
      final completedDaysCount = await _toDoRepository.getMarkedCompletedDaysCount();
      final completionRatio = totalDaysCount > 0 ? completedDaysCount / totalDaysCount : 0;

      final latestStreakCount = await _toDoRepository.getLatestStreakCount();
      final latestStreakEndMillis = await _toDoRepository.getLatestStreakEndMillis();
      final longestStreakCount = await _toDoRepository.getLongestStreakCount();
      final longestStreakEndMillis = await _toDoRepository.getLongestStreakEndMillis();
      final selectedPet = await _getSelectedPetUsecase.invoke();
      final rankingUserInfo = RankingUserInfo(
        uid: uid,
        name: userName,
        completionRatio: completionRatio,
        latestStreak: latestStreakCount,
        latestStreakEndMillis: latestStreakEndMillis,
        longestStreak: longestStreakCount,
        longestStreakEndMillis: longestStreakEndMillis,
        petKey: selectedPet.key,
        petPhaseIndex: selectedPet.currentPhaseIndex,
        firstLaunchDateMillis: firstLaunchDate.millisecondsSinceEpoch,
        completedDaysCount: completedDaysCount,
      );

      _prefsRepository.setLastUpdatedMyRankingUserInfoLocalTimeMillis(DateTime.now().millisecondsSinceEpoch);

      return _rankingRepository.setMyRankingUserInfo(rankingUserInfo);
    }
  }
}