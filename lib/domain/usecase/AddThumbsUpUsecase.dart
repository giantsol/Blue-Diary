
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/RankingRepository.dart';

class AddThumbsUpUsecase {
  final RankingRepository _rankingRepository;

  AddThumbsUpUsecase(this._rankingRepository);

  void invoke(RankingUserInfo userInfo) {
    _rankingRepository.addThumbsUp(userInfo);
  }
}