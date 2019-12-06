
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/usecase/GetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class SignInWithFacebookUsecase {
  final _userRepository = dependencies.userRepository;

  final _setMyRankingUserInfoUsecase = SetMyRankingUserInfoUsecase();
  final _getMyRankingUserInfoUsecase = GetMyRankingUserInfoUsecase();

  Future<RankingUserInfo> invoke() async {
    final success = await _userRepository.signInWithFacebook();
    if (!success) {
      return RankingUserInfo.INVALID;
    }

    await _setMyRankingUserInfoUsecase.invoke();
    return _getMyRankingUserInfoUsecase.invoke();
  }
}