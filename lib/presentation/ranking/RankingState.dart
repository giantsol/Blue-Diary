
import 'package:todo_app/domain/entity/MyRankingUserInfoState.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';

class RankingState {
  final RankingViewState viewState;
  final List<RankingUserInfo> rankingUserInfos;
  final bool hasMoreRankingInfos;
  final MyRankingUserInfoState myRankingUserInfoState;
  final bool signInDialogShown;
  final Map<String, bool> thumbedUpUids;
  final bool showMyRankingInfoLoading;
  final bool isRankingUserInfosLoading;
  final bool isEditingDisplayName;
  final String displayNameEditorText;

  const RankingState({
    this.viewState = RankingViewState.LOADING,
    this.rankingUserInfos = const [],
    this.hasMoreRankingInfos = false,
    this.myRankingUserInfoState = MyRankingUserInfoState.INVALID,
    this.signInDialogShown = false,
    this.thumbedUpUids = const {},
    this.showMyRankingInfoLoading = false,
    this.isRankingUserInfosLoading = true,
    this.isEditingDisplayName = false,
    this.displayNameEditorText = '',
  });

  RankingState buildNew({
    RankingViewState viewState,
    List<RankingUserInfo> rankingUserInfos,
    bool hasMoreRankingInfos,
    MyRankingUserInfoState myRankingUserInfoState,
    bool signInDialogShown,
    Map<String, bool> thumbedUpUids,
    bool showMyRankingInfoLoading,
    bool isRankingUserInfosLoading,
    bool isEditingDisplayName,
    String displayNameEditorText,
  }) {
    return RankingState(
      viewState: viewState ?? this.viewState,
      rankingUserInfos: rankingUserInfos ?? this.rankingUserInfos,
      hasMoreRankingInfos: hasMoreRankingInfos ?? this.hasMoreRankingInfos,
      myRankingUserInfoState: myRankingUserInfoState ?? this.myRankingUserInfoState,
      signInDialogShown: signInDialogShown ?? this.signInDialogShown,
      thumbedUpUids: thumbedUpUids ?? this.thumbedUpUids,
      showMyRankingInfoLoading: showMyRankingInfoLoading ?? this.showMyRankingInfoLoading,
      isRankingUserInfosLoading: isRankingUserInfosLoading ?? this.isRankingUserInfosLoading,
      isEditingDisplayName: isEditingDisplayName ?? this.isEditingDisplayName,
      displayNameEditorText: displayNameEditorText ?? this.displayNameEditorText,
    );
  }
}

enum RankingViewState {
  LOADING,
  NORMAL,
}
