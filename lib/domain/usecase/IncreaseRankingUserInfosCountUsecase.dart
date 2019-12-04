
import 'package:todo_app/presentation/App.dart';

class IncreaseRankingUserInfosCountUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  void invoke() {
    _rankingRepository.increaseRankingUserInfosCount();
  }
}