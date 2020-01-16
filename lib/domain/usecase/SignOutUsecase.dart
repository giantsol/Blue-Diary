
import 'package:todo_app/presentation/App.dart';

class SignOutUsecase {
  final _userRepository = dependencies.userRepository;
  final _rankingRepository = dependencies.rankingRepository;
  final _prefsRepository = dependencies.prefsRepository;

  Future<bool> invoke() async {
    final uid = await _userRepository.getUserId();
    if (uid.isEmpty) {
      return false;
    }

    final deleted = await _rankingRepository.deleteRankingUserInfo(uid);
    if (deleted) {
      _prefsRepository.setLastUpdatedMyRankingUserInfoLocalTimeMillis(0);
      return await _userRepository.signOut();
    } else {
      return false;
    }
  }
}