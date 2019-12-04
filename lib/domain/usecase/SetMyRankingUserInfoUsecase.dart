
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';
import 'package:todo_app/domain/usecase/GetSelectedPetUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';

class SetMyRankingUserInfoUsecase {
  final UserRepository _userRepository;
  final ToDoRepository _toDoRepository;
  final RankingRepository _rankingRepository;
  final PrefsRepository _prefsRepository;

  final GetSelectedPetUsecase _getSelectedPetUsecase;
  final GetTodayUsecase _getTodayUsecase;

  SetMyRankingUserInfoUsecase(this._userRepository, this._toDoRepository, this._rankingRepository, this._prefsRepository, DateRepository dateRepository, PetRepository petRepository)
    : _getSelectedPetUsecase = GetSelectedPetUsecase(petRepository),
      _getTodayUsecase = GetTodayUsecase(dateRepository, _prefsRepository);

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