
import 'package:todo_app/domain/entity/RankingUserInfo.dart';

class MyRankingUserInfoState {
  static const MyRankingUserInfoState INVALID = MyRankingUserInfoState(
    data: null,
    isSignedIn: false
  );

  final RankingUserInfo data;
  final bool isSignedIn;

  const MyRankingUserInfoState({
    this.data,
    this.isSignedIn
  });
}