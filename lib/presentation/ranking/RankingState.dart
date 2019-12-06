
import 'package:todo_app/domain/entity/RankingUserInfo.dart';

class RankingState {
  final RankingViewState viewState;
  final List<RankingUserInfo> rankingUserInfos;
  final bool hasMoreRankingInfos;
  final RankingUserInfo myRankingUserInfo;
  final bool signInDialogShown;
  final Map<String, bool> thumbedUpUids;
  final bool showMyRankingInfoLoading;

  const RankingState({
    this.viewState = RankingViewState.LOADING,
    this.rankingUserInfos = const [],
    this.hasMoreRankingInfos = false,
    this.myRankingUserInfo = RankingUserInfo.INVALID,
    this.signInDialogShown = false,
    this.thumbedUpUids = const {},
    this.showMyRankingInfoLoading = false,
  });

  RankingState buildNew({
    RankingViewState viewState,
    List<RankingUserInfo> rankingUserInfos,
    bool hasMoreRankingInfos,
    RankingUserInfo myRankingUserInfo,
    bool signInDialogShown,
    Map<String, bool> thumbedUpUids,
    bool showMyRankingInfoLoading,
  }) {
    return RankingState(
      viewState: viewState ?? this.viewState,
      rankingUserInfos: rankingUserInfos ?? this.rankingUserInfos,
      hasMoreRankingInfos: hasMoreRankingInfos ?? this.hasMoreRankingInfos,
      myRankingUserInfo: myRankingUserInfo ?? this.myRankingUserInfo,
      signInDialogShown: signInDialogShown ?? this.signInDialogShown,
      thumbedUpUids: thumbedUpUids ?? this.thumbedUpUids,
      showMyRankingInfoLoading: showMyRankingInfoLoading ?? this.showMyRankingInfoLoading,
    );
  }
}

enum RankingViewState {
  LOADING,
  NORMAL,
}
