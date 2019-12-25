
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/presentation/App.dart';

class AddThumbsUpUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  void invoke(String uid) {
    _rankingRepository.addThumbsUp(uid);
  }
}