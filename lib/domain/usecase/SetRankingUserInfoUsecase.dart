
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/presentation/App.dart';

class SetRankingUserInfoUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  void invoke(RankingUserInfo rankingUserInfo) {
    _rankingRepository.setRankingUserInfo(rankingUserInfo);
  }
}