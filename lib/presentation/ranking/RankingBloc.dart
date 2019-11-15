
import 'dart:async';

import 'package:rxdart/rxdart.dart';
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
    final userDisplayName = await _usecases.getUserDisplayName();
    _state.add(_state.value.buildNew(
      userDisplayName: userDisplayName,
    ));

    _rankingUserInfosEventSubscription = _usecases.observeRankingUserInfosEvent()
      .listen((event) {
      _state.add(_state.value.buildNew(
        rankingUserInfos: event.rankingUserInfos,
        hasMoreRaningInfos: event.hasMore,
      ));
    });

    _initRankingsCount();
  }

  void _initRankingsCount() {
    _usecases.initRankingUserInfosCount();
  }

  Future<void> onGoogleSignInClicked() async {
    final success = await _usecases.signInWithGoogle();
    if (success) {
      final userDisplayName = await _usecases.getUserDisplayName();
      _state.add(_state.value.buildNew(
        userDisplayName: userDisplayName,
      ));
    }
  }

  Future<void> onFacebookSignInClicked() async {
    final success = await _usecases.signInWithFacebook();
    if (success) {
      final userDisplayName = await _usecases.getUserDisplayName();
      _state.add(_state.value.buildNew(
        userDisplayName: userDisplayName,
      ));
    }
  }

  Future<void> onSignOutClicked() async {
    final uid = await _usecases.getUserId();
    await _usecases.deleteRankingUserInfo(uid);

    final success = await _usecases.signOut();
    if (success) {
      final userDisplayName = await _usecases.getUserDisplayName();
      _state.add(_state.value.buildNew(
        userDisplayName: userDisplayName,
      ));
      _initRankingsCount();
    }
  }

  Future<void> onSubmitMyScoreClicked() async {
    final uid = await _usecases.getUserId();
    if (uid.isNotEmpty) {
      final userName = await _usecases.getUserDisplayName();
      final completionRatio = await _usecases.getCompletionRatio();
      final latestStreakCount = await _usecases.getLatestStreakCount();
      final maxStreakCount = await _usecases.getMaxStreakCount();
      final rankingUserInfo = RankingUserInfo(
        name: userName,
        completionRatio: completionRatio,
        latestStreak: latestStreakCount,
        maxStreak: maxStreakCount,
      );
      await _usecases.setRankingUserInfo(uid, rankingUserInfo);
    }
  }

  void onLoadMoreRankingInfosClicked() {
    _usecases.increaseRankingUserInfosCount();
  }

  void dispose() {
    _rankingUserInfosEventSubscription?.cancel();
  }
}