
import 'package:todo_app/domain/repository/RankingRepository.dart';

class IncreaseRankingUserInfosCountUsecase {
  final RankingRepository _rankingRepository;

  IncreaseRankingUserInfosCountUsecase(this._rankingRepository);

  void invoke() {
    _rankingRepository.increaseRankingUserInfosCount();
  }
}