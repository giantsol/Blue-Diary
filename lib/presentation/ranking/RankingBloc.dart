
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/usecase/RankingUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/ranking/RankingState.dart';

class RankingBloc {
  final _state = BehaviorSubject<RankingState>.seeded(RankingState());
  RankingState getInitialState() => _state.value;
  Stream<RankingState> observeState() => _state.distinct();

  final RankingUsecases _usecases = dependencies.rankingUsecases;
  StreamSubscription _rankingUserInfosEventSubscription;

  RankingBloc() {
    _initState();
  }

  Future<void> _initState() async {
    final today = await _usecases.getToday();
    //todo: if today date is invalid, show error screen
    final myRankingInfo = await _usecases.getMyRankingUserInfo();

    _state.add(_state.value.buildNew(
      viewState: RankingViewState.NORMAL,
      today: today,
      myRankingUserInfo: myRankingInfo,
    ));

    _rankingUserInfosEventSubscription = _usecases.observeRankingUserInfosEvent()
      .listen((event) {
      _state.add(_state.value.buildNew(
        rankingUserInfos: event.rankingUserInfos,
        hasMoreRankingInfos: event.hasMore,
      ));
    });

    _initRankingsCount();

    // todo: update my ranking info once if last updated threshold is valid
  }

  void _initRankingsCount() {
    _usecases.initRankingUserInfosCount();
  }

  Future<void> onGoogleSignInClicked() async {
    final success = await _usecases.signInWithGoogle();
    if (success) {
      await _uploadMyRankingInfo();
      final myRankingInfo = await _usecases.getMyRankingUserInfo();
      _state.add(_state.value.buildNew(
        myRankingUserInfo: myRankingInfo,
      ));
    }

    _state.add(_state.value.buildNew(
      signInDialogShown: false,
    ));
  }

  Future<void> onFacebookSignInClicked() async {
    final success = await _usecases.signInWithFacebook();
    if (success) {
      await _uploadMyRankingInfo();
      final myRankingInfo = await _usecases.getMyRankingUserInfo();
      _state.add(_state.value.buildNew(
        myRankingUserInfo: myRankingInfo,
      ));
    }

    _state.add(_state.value.buildNew(
      signInDialogShown: false,
    ));
  }

  Future<void> onSignOutClicked() async {
    final uid = await _usecases.getUserId();
    await _usecases.deleteRankingUserInfo(uid);

    final success = await _usecases.signOut();
    if (success) {
      _state.add(_state.value.buildNew(
        myRankingUserInfo: RankingUserInfo.INVALID,
      ));

      _initRankingsCount();
    }
  }

  Future<void> onRefreshMyRankingInfoClicked() async {
    await _uploadMyRankingInfo();
    final myRankingInfo = await _usecases.getMyRankingUserInfo();
    _state.add(_state.value.buildNew(
      myRankingUserInfo: myRankingInfo,
    ));
  }

  Future<void> _uploadMyRankingInfo() async {
    final uid = await _usecases.getUserId();
    if (uid.isNotEmpty) {
      final userName = await _usecases.getUserDisplayName();
      final firstLaunchDate = await _usecases.getFirstLaunchDate();
      final completedDaysCount = await _usecases.getCompletedDaysCount();
      final latestStreakCount = await _usecases.getLatestStreakCount();
      final latestStreakEndMillis = await _usecases.getLatestStreakEndMillis();
      final longestStreakCount = await _usecases.getLongestStreakCount();
      final longestStreakEndMillis = await _usecases.getLongestStreakEndMillis();
      final selectedPet = await _usecases.getSelectedPet();
      final rankingUserInfo = RankingUserInfo(
        uid: uid,
        name: userName,
        firstLaunchDateMillis: firstLaunchDate != DateRepository.INVALID_DATE ? firstLaunchDate.millisecondsSinceEpoch : 0,
        completedDaysCount: completedDaysCount,
        latestStreak: latestStreakCount,
        latestStreakEndMillis: latestStreakEndMillis,
        longestStreak: longestStreakCount,
        longestStreakEndMillis: longestStreakEndMillis,
        petKey: selectedPet.key,
        petPhaseIndex: selectedPet.currentPhaseIndex,
      );
      return _usecases.setMyRankingUserInfo(rankingUserInfo);
    }
  }

  void onLoadMoreRankingInfosClicked() {
    _usecases.increaseRankingUserInfosCount();
  }

  void onSignInAndJoinClicked() {
    _state.add(_state.value.buildNew(
      signInDialogShown: true,
    ));
  }

  bool handleBackPress() {
    if (_state.value.signInDialogShown) {
      _state.add(_state.value.buildNew(
        signInDialogShown: false,
      ));
      return true;
    }

    return false;
  }

  void onDismissSignInDialogClicked() {
    _state.add(_state.value.buildNew(
      signInDialogShown: false,
    ));
  }

  void onThumbsUpClicked(RankingUserInfo userInfo) {
    final updatedThumbedUpUids = Map.of(_state.value.thumbedUpUids);
    updatedThumbedUpUids[userInfo.uid] = true;
    _state.add(_state.value.buildNew(
      thumbedUpUids: updatedThumbedUpUids,
    ));

    _usecases.increaseThumbsUp(userInfo);
  }

  void dispose() {
    _rankingUserInfosEventSubscription?.cancel();
  }
}