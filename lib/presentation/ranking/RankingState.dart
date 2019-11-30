
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';

class RankingState {
  final RankingViewState viewState;
  final DateTime today;
  final List<RankingUserInfo> rankingUserInfos;
  final bool hasMoreRankingInfos;
  final RankingUserInfo myRankingInfo;
  final bool signInDialogShown;
  final Map<String, bool> thumbedUpUids;

  const RankingState({
    this.viewState = RankingViewState.LOADING,
    this.today,
    this.rankingUserInfos = const [],
    this.hasMoreRankingInfos = false,
    this.myRankingInfo = RankingUserInfo.INVALID,
    this.signInDialogShown = false,
    this.thumbedUpUids = const {},
  });

  RankingState buildNew({
    RankingViewState viewState,
    DateTime today,
    List<RankingUserInfo> rankingUserInfos,
    bool hasMoreRankingInfos,
    RankingUserInfo myRankingUserInfo,
    bool signInDialogShown,
    Map<String, bool> thumbedUpUids,
  }) {
    return RankingState(
      viewState: viewState ?? this.viewState,
      today: today ?? this.today,
      rankingUserInfos: rankingUserInfos ?? this.rankingUserInfos,
      hasMoreRankingInfos: hasMoreRankingInfos ?? this.hasMoreRankingInfos,
      myRankingInfo: myRankingUserInfo ?? this.myRankingInfo,
      signInDialogShown: signInDialogShown ?? this.signInDialogShown,
      thumbedUpUids: thumbedUpUids ?? this.thumbedUpUids,
    );
  }
}

enum RankingViewState {
  LOADING,
  NORMAL,
}
