
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/presentation/App.dart';

class AddThumbUpUsecase {
  final _rankingRepository = dependencies.rankingRepository;

  Future<void> invoke(String uid) {
    return _rankingRepository.addThumbUp(uid);
  }
}