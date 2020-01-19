
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/usecase/GetSelectedPetUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/domain/usecase/SyncTodayWithServerUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class SetMyRankingUserInfoUsecase {
  final _userRepository = dependencies.userRepository;
  final _toDoRepository = dependencies.toDoRepository;
  final _rankingRepository = dependencies.rankingRepository;
  final _prefsRepository = dependencies.prefsRepository;

  final _syncTodayWithServerUsecase = SyncTodayWithServerUsecase();
  final _getSelectedPetUsecase = GetSelectedPetUsecase();
  final _getTodayUsecase = GetTodayUsecase();

  Future<SetMyRankingUserInfoResult> invoke() async {
    final lastUpdatedLocalTimeMillis = await _prefsRepository.getLastUpdatedMyRankingUserInfoLocalTimeMillis();
    final currentLocalTimeMillis = DateTime.now().millisecondsSinceEpoch;
    // 1 minute
    final canUpdate = (currentLocalTimeMillis - lastUpdatedLocalTimeMillis).abs() > 1 * 60 * 1000;
    if (!canUpdate) {
      return SetMyRankingUserInfoResult.FAIL_TRY_LATER;
    }

    final todaySynced = await _syncTodayWithServerUsecase.invoke();
    if (!todaySynced) {
      return SetMyRankingUserInfoResult.FAIL_NO_INTERNET;
    }

    final uid = await _userRepository.getUserId();
    final firstLaunchDateString = await _prefsRepository.getFirstLaunchDateString();
    final today = await _getTodayUsecase.invoke();

    if (uid.isEmpty || firstLaunchDateString.isEmpty || today == DateRepository.INVALID_DATE) {
      return SetMyRankingUserInfoResult.FAIL;
    }

    final userName = await _userRepository.getUserDisplayName();
    final firstLaunchDate = DateTime.parse(firstLaunchDateString);
    final beforeTodayDaysCount = today.difference(firstLaunchDate).inDays;
    final completedDaysCount = await _toDoRepository.getMarkedCompletedDaysCount();
    final double completionRatio = completedDaysCount > beforeTodayDaysCount ? 1
      : beforeTodayDaysCount > 0 ? completedDaysCount / beforeTodayDaysCount : 0;

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

    final updateSuccess = await _rankingRepository.setMyRankingUserInfo(rankingUserInfo);
    if (updateSuccess) {
      _prefsRepository.setLastUpdatedMyRankingUserInfoLocalTimeMillis(currentLocalTimeMillis);
      return SetMyRankingUserInfoResult.SUCCESS;
    } else {
      return SetMyRankingUserInfoResult.FAIL_NO_INTERNET;
    }
  }
}

enum SetMyRankingUserInfoResult {
  SUCCESS,
  FAIL,
  FAIL_TRY_LATER,
  FAIL_NO_INTERNET,
}