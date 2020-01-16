
import 'package:todo_app/presentation/App.dart';

class InitRankingUserInfosCountUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  void invoke() {
    _rankingRepository.initRankingUserInfosCount();
  }
}