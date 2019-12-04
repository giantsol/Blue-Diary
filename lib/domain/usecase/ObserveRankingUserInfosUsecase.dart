
import 'package:todo_app/domain/entity/RankingUserInfosEvent.dart';
import 'package:todo_app/presentation/App.dart';

class ObserveRankingUserInfosUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  Stream<RankingUserInfosEvent> invoke() {
    return _rankingRepository.observeRankingUserInfos();
  }
}