
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';

class ObserveRankingUserInfosUsecase {
  final RankingRepository _rankingRepository;

  ObserveRankingUserInfosUsecase(this._rankingRepository);

  Stream<RankingUserInfosEvent> invoke() {
    return _rankingRepository.observeRankingUserInfos();
  }
}