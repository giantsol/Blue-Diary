
import 'package:todo_app/domain/entity/RankingUserInfo.dart';

class MyRankingUserInfoState {
  static const MyRankingUserInfoState INVALID = MyRankingUserInfoState(null, false);

  final RankingUserInfo data;
  final bool isSignedIn;

  const MyRankingUserInfoState(this.data, this.isSignedIn);
}