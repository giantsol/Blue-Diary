
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/usecase/GetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class SignOutUsecase {
  final _userRepository = dependencies.userRepository;
  final _rankingRepository = dependencies.rankingRepository;
  final _prefsRepository = dependencies.prefsRepository;

  final _getMyRankingUserInfoUsecase = GetMyRankingUserInfoUsecase();

  Future<RankingUserInfo> invoke() async {
    final uid = await _userRepository.getUserId();
    if (uid.isEmpty) {
      return RankingUserInfo.INVALID;
    }

    final signOutSuccess = await _userRepository.signOut();
    if (signOutSuccess) {
      _prefsRepository.setLastUpdatedMyRankingUserInfoLocalTimeMillis(0);
      await _rankingRepository.deleteRankingUserInfo(uid);
    }

    return _getMyRankingUserInfoUsecase.invoke();
  }
}