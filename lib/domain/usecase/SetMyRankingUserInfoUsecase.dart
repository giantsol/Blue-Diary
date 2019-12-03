
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';
import 'package:todo_app/domain/usecase/GetCompletionRatioUsecase.dart';
import 'package:todo_app/domain/usecase/GetSelectedPetUsecase.dart';

class SetMyRankingUserInfoUsecase {
  final UserRepository _userRepository;
  final ToDoRepository _toDoRepository;
  final RankingRepository _rankingRepository;

  final GetCompletionRatioUsecase _getCompletionRatioUsecase;
  final GetSelectedPetUsecase _getSelectedPetUsecase;

  SetMyRankingUserInfoUsecase(this._userRepository, this._toDoRepository, this._rankingRepository, PrefsRepository prefsRepository, DateRepository dateRepository, PetRepository petRepository)
    : _getCompletionRatioUsecase = GetCompletionRatioUsecase(prefsRepository, _toDoRepository, dateRepository),
      _getSelectedPetUsecase = GetSelectedPetUsecase(petRepository);

  Future<void> invoke() async {
    final uid = await _userRepository.getUserId();
    if (uid.isNotEmpty) {
      final userName = await _userRepository.getUserDisplayName();
      final completionRatio = await _getCompletionRatioUsecase.invoke();
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
      );
      return _rankingRepository.setMyRankingUserInfo(rankingUserInfo);
    }
  }
}