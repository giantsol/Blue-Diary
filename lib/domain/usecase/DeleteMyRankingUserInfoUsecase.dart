
import 'package:todo_app/domain/repository/RankingRepository.dart';
import 'package:todo_app/domain/repository/UserRepository.dart';

class DeleteMyRankingUserInfoUsecase {
  final UserRepository _userRepository;
  final RankingRepository _rankingRepository;

  DeleteMyRankingUserInfoUsecase(this._userRepository, this._rankingRepository);

  Future<void> invoke() async {
    final uid = await _userRepository.getUserId();
    if (uid.isNotEmpty) {
      return _rankingRepository.deleteRankingUserInfo(uid);
    }
  }
}