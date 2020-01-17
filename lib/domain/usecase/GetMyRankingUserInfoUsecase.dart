
import 'package:todo_app/domain/entity/MyRankingUserInfoState.dart';
import 'package:todo_app/domain/usecase/IsSignedInUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class GetMyRankingUserInfoStateUsecase {
  final _userRepository = dependencies.userRepository;
  final _rankingRepository = dependencies.rankingRepository;

  final _isSignedInUsecase = IsSignedInUsecase();

  Future<MyRankingUserInfoState> invoke() async {
    final uid = await _userRepository.getUserId();
    final data = await _rankingRepository.getRankingUserInfo(uid);
    final isSignedIn = await _isSignedInUsecase.invoke();
    return MyRankingUserInfoState(data: data, isSignedIn: isSignedIn);
  }
}