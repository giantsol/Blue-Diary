
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
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
    final myRankingInfo = await _usecases.getMyRankingUserInfo();

    _state.add(_state.value.buildNew(
      viewState: RankingViewState.NORMAL,
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

  Future<void> _uploadMyRankingInfo() async {
    final uid = await _usecases.getUserId();
    if (uid.isNotEmpty) {
      final userName = await _usecases.getUserDisplayName();
      final completionRatio = await _usecases.getCompletionRatio();
      final latestStreakCount = await _usecases.getLatestStreakCount();
      final maxStreakCount = await _usecases.getMaxStreakCount();
      final selectedPet = await _usecases.getSelectedPet();
      final rankingUserInfo = RankingUserInfo(
        uid: uid,
        name: userName,
        completionRatio: completionRatio,
        latestStreak: latestStreakCount,
        longestStreak: maxStreakCount,
        petKey: selectedPet.key,
        petPhaseIndex: selectedPet.currentPhaseIndex,
      );
      await _usecases.setRankingUserInfo(uid, rankingUserInfo);
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

  void dispose() {
    _rankingUserInfosEventSubscription?.cancel();
  }
}