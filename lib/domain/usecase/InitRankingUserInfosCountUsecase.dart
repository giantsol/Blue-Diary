
import 'package:todo_app/domain/repository/RankingRepository.dart';

class InitRankingUserInfosCountUsecase {
  final RankingRepository _rankingRepository;

  InitRankingUserInfosCountUsecase(this._rankingRepository);

  void invoke() {
    _rankingRepository.initRankingUserInfosCount();
  }
}