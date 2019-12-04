
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/presentation/App.dart';

class GetMyRankingUserInfoUsecase {
  final _userRepository = dependencies.userRepository;
  final _rankingRepository = dependencies.rankingRepository;

  Future<RankingUserInfo> invoke() async {
    final uid = await _userRepository.getUserId();
    if (uid.isEmpty) {
      return RankingUserInfo.INVALID;
    } else {
      return _rankingRepository.getRankingUserInfo(uid);
    }
  }
}