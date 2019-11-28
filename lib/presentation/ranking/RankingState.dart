
import 'package:todo_app/domain/entity/RankingUserInfo.dart';

class RankingState {
  final RankingViewState viewState;
  final List<RankingUserInfo> rankingUserInfos;
  final bool hasMoreRankingInfos;
  final RankingUserInfo myRankingInfo;
  final bool signInDialogShown;

  const RankingState({
    this.viewState = RankingViewState.LOADING,
    this.rankingUserInfos = const [],
    this.hasMoreRankingInfos = false,
    this.myRankingInfo = RankingUserInfo.INVALID,
    this.signInDialogShown = false,
  });

  RankingState buildNew({
    RankingViewState viewState,
    List<RankingUserInfo> rankingUserInfos,
    bool hasMoreRankingInfos,
    RankingUserInfo myRankingUserInfo,
    bool signInDialogShown,
  }) {
    return RankingState(
      viewState: viewState ?? this.viewState,
      rankingUserInfos: rankingUserInfos ?? this.rankingUserInfos,
      hasMoreRankingInfos: hasMoreRankingInfos ?? this.hasMoreRankingInfos,
      myRankingInfo: myRankingUserInfo ?? this.myRankingInfo,
      signInDialogShown: signInDialogShown ?? this.signInDialogShown,
    );
  }
}

enum RankingViewState {
  LOADING,
  NORMAL,
}
