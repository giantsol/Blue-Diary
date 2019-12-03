
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';

class GetMyRankingUserInfoUsecase {
  final UserRepository _userRepository;
  final RankingRepository _rankingRepository;

  GetMyRankingUserInfoUsecase(this._userRepository, this._rankingRepository);

  Future<RankingUserInfo> invoke() async {
    final uid = await _userRepository.getUserId();
    if (uid.isEmpty) {
      return RankingUserInfo.INVALID;
    } else {
      return _rankingRepository.getRankingUserInfo(uid);
    }
  }
}