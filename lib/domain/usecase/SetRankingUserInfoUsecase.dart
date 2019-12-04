
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';

class SetRankingUserInfoUsecase {
  final RankingRepository _rankingRepository;

  SetRankingUserInfoUsecase(this._rankingRepository);

  void invoke(RankingUserInfo rankingUserInfo) {
    _rankingRepository.setRankingUserInfo(rankingUserInfo);
  }
}