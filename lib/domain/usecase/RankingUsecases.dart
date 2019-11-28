
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';

class RankingUsecases {
  final UserRepository _userRepository;
  final DateRepository _dateRepository;
  final PrefsRepository _prefsRepository;
  final ToDoRepository _toDoRepository;
  final RankingRepository _rankingRepository;
  final PetRepository _petRepository;

  const RankingUsecases(this._userRepository, this._dateRepository, this._prefsRepository, this._toDoRepository, this._rankingRepository, this._petRepository);

  Future<String> getUserDisplayName() {
    return _userRepository.getUserDisplayName();
  }

  Future<RankingUserInfo> getMyRankingUserInfo() async {
    final uid = await _userRepository.getUserId();
    if (uid.isEmpty) {
      return RankingUserInfo.INVALID;
    } else {
      return _rankingRepository.getRankingUserInfo(uid);
    }
  }

  Future<bool> signInWithGoogle() {
    return _userRepository.signInWithGoogle();
  }

  Future<bool> signInWithFacebook() {
    return _userRepository.signInWithFacebook();
  }

  Future<bool> signOut() {
    return _userRepository.signOut();
  }

  Future<String> getUserId() {
    return _userRepository.getUserId();
  }

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

  Future<int> getLatestStreakEndMillis() {
    return _toDoRepository.getLatestStreakEndMillis();
  }

  Future<int> getLongestStreakCount() {
    return _toDoRepository.getLongestStreakCount();
  }

  Future<int> getLongestStreakEndMillis() {
    return _toDoRepository.getLongestStreakEndMillis();
  }

  Future<void> setRankingUserInfo(String uid, RankingUserInfo info) {
    return _rankingRepository.setRankingUserInfo(uid, info);
  }

  Stream<RankingUserInfosEvent> observeRankingUserInfosEvent() {
    return _rankingRepository.observeRankingUserInfosEvent();
  }

  void initRankingUserInfosCount() {
    _rankingRepository.initRankingUserInfosCount();
  }

  void increaseRankingUserInfosCount() {
    _rankingRepository.increaseRankingUserInfosCount();
  }

  Future<void> deleteRankingUserInfo(String uid) {
    return _rankingRepository.deleteRankingUserInfo(uid);
  }

  Future<Pet> getSelectedPet() {
    return _petRepository.getSelectedPet();
  }
}