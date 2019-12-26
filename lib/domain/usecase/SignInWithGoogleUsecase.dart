
import 'package:todo_app/domain/entity/MyRankingUserInfoState.dart';
import 'package:todo_app/domain/usecase/GetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class SignInWithGoogleUsecase {
  final _userRepository = dependencies.userRepository;

  final _setMyRankingUserInfoUsecase = SetMyRankingUserInfoUsecase();
  final _getMyRankingUserInfoStateUsecase = GetMyRankingUserInfoStateUsecase();

  Future<MyRankingUserInfoState> invoke() async {
    final success = await _userRepository.signInWithGoogle();
    if (success) {
      await _setMyRankingUserInfoUsecase.invoke();
    }

    return _getMyRankingUserInfoStateUsecase.invoke();
  }
}