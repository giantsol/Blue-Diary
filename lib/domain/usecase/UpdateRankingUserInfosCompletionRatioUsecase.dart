
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/presentation/App.dart';

class UpdateRankingUserInfosCompletionRatioUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  Future<void> invoke(List<RankingUserInfo> infos) {
    return _rankingRepository.updateCompletionRatios(infos);
  }
}