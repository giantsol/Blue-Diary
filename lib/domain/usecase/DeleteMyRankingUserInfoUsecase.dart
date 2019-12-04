
import 'package:todo_app/presentation/App.dart';

class DeleteMyRankingUserInfoUsecase {
  final _userRepository = dependencies.userRepository;
  final _rankingRepository = dependencies.rankingRepository;

  Future<void> invoke() async {
    final uid = await _userRepository.getUserId();
    if (uid.isNotEmpty) {
      return _rankingRepository.deleteRankingUserInfo(uid);
    }
  }
}