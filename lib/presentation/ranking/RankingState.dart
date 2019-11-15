
import 'package:todo_app/domain/entity/RankingUserInfo.dart';

class RankingState {
  final String userDisplayName;
  final List<RankingUserInfo> rankingUserInfos;
  final bool hasMoreRankingInfos;

  const RankingState({
    this.userDisplayName = '',
    this.rankingUserInfos = const [],
    this.hasMoreRankingInfos = false,
  });

  RankingState buildNew({
    String userDisplayName,
    List<RankingUserInfo> rankingUserInfos,
    bool hasMoreRaningInfos,
  }) {
    return RankingState(
      userDisplayName: userDisplayName ?? this.userDisplayName,
      rankingUserInfos: rankingUserInfos ?? this.rankingUserInfos,
      hasMoreRankingInfos: hasMoreRaningInfos ?? this.hasMoreRankingInfos,
    );
  }
}