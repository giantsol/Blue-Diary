
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/usecase/AddThumbsUpUsecase.dart';
import 'package:todo_app/domain/usecase/GetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/domain/usecase/IncreaseRankingUserInfosCountUsecase.dart';
import 'package:todo_app/domain/usecase/InitRankingUserInfosCountUsecase.dart';
import 'package:todo_app/domain/usecase/ObserveRankingUserInfosUsecase.dart';
import 'package:todo_app/domain/usecase/SetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SetRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SignInWithFacebookUsecase.dart';
import 'package:todo_app/domain/usecase/SignInWithGoogleUsecase.dart';
import 'package:todo_app/domain/usecase/SignOutUsecase.dart';
import 'package:todo_app/domain/usecase/SyncTodayWithServerUsecase.dart';
import 'package:todo_app/presentation/ranking/RankingState.dart';

class RankingBloc {
  final _state = BehaviorSubject<RankingState>.seeded(RankingState());
  RankingState getInitialState() => _state.value;
  Stream<RankingState> observeState() => _state.distinct();

  RankingBlocDelegator delegator;

  StreamSubscription _rankingUserInfosEventSubscription;

  final _getMyRankingUserInfoUsecase = GetMyRankingUserInfoUsecase();
  final _observeRankingUserInfosUsecase = ObserveRankingUserInfosUsecase();
  final _initRankingUserInfosCountUsecase = InitRankingUserInfosCountUsecase();
  final _setMyRankingUserInfoUsecase = SetMyRankingUserInfoUsecase();
  final _signInWithGoogleUsecase = SignInWithGoogleUsecase();
  final _signInWithFacebookUsecase = SignInWithFacebookUsecase();
  final _signOutUsecase = SignOutUsecase();
  final _increaseRankingUserInfosCountUsecase = IncreaseRankingUserInfosCountUsecase();
  final _addThumbsUpUsecase = AddThumbsUpUsecase();
  final _getTodayUsecase = GetTodayUsecase();
  final _setRankingUserInfoUsecase = SetRankingUserInfoUsecase();
  final _syncTodayWithServerUsecase = SyncTodayWithServerUsecase();

  RankingBloc() {
    _initState();
  }

  void updateDelegator(RankingBlocDelegator delegator) {
    this.delegator = delegator;
  }

  Future<void> _initState() async {
    final myRankingInfo = await _getMyRankingUserInfoUsecase.invoke();

    _state.add(_state.value.buildNew(
      viewState: RankingViewState.NORMAL,
      myRankingUserInfo: myRankingInfo,
    ));

    _rankingUserInfosEventSubscription = _observeRankingUserInfosUsecase.invoke()
      .listen((event) async {
      _state.add(_state.value.buildNew(
        rankingUserInfos: event.rankingUserInfos,
        hasMoreRankingInfos: event.hasMore,
      ));

      final todaySyncedSuccessful = await _syncTodayWithServerUsecase.invoke();
      if (todaySyncedSuccessful) {
        final today = await _getTodayUsecase.invoke();
        if (today != DateRepository.INVALID_DATE) {
          event.rankingUserInfos.forEach((it) {
            final firstLaunchDate = it.firstLaunchDateMillis != 0 ? DateTime.fromMillisecondsSinceEpoch(it.firstLaunchDateMillis)
              : DateRepository.INVALID_DATE;
            if (firstLaunchDate != DateRepository.INVALID_DATE) {
              final totalDaysCount = today.difference(firstLaunchDate).inDays + 1;
              final completedDaysCount = it.completedDaysCount;
              final double completionRatio = totalDaysCount > 0 ? completedDaysCount / totalDaysCount : 0;

              if (it.completionRatio != completionRatio) {
                final updated = it.buildNew(completionRatio: completionRatio);
                debugPrint('updating completion ratio of id: ${updated.uid}');
                _setRankingUserInfoUsecase.invoke(updated);
              }
            }
          });
        }
      }
    });

    _initRankingUserInfosCountUsecase.invoke();
  }

  Future<void> onGoogleSignInClicked() async {
    _state.add(_state.value.buildNew(
      signInDialogShown: false,
      showMyRankingInfoLoading: true,
    ));

    final myRankingUserInfo = await _signInWithGoogleUsecase.invoke();
    _state.add(_state.value.buildNew(
      myRankingUserInfo: myRankingUserInfo,
      showMyRankingInfoLoading: false,
    ));
  }

  Future<void> onFacebookSignInClicked() async {
    _state.add(_state.value.buildNew(
      signInDialogShown: false,
      showMyRankingInfoLoading: true,
    ));

    final myRankingUserInfo = await _signInWithFacebookUsecase.invoke();
    _state.add(_state.value.buildNew(
      myRankingUserInfo: myRankingUserInfo,
      showMyRankingInfoLoading: false,
    ));
  }

  void onSignOutClicked(BuildContext context) {
    if (_state.value.showMyRankingInfoLoading) {
      return;
    }

    final title = AppLocalizations.of(context).signOutTitle;
    final body = AppLocalizations.of(context).signOutBody;
    Utils.showAppDialog(context, title, body, null, () async {
      _state.add(_state.value.buildNew(
        showMyRankingInfoLoading: true,
      ));

      final myRankingUserInfo = await _signOutUsecase.invoke();
      _state.add(_state.value.buildNew(
        myRankingUserInfo: myRankingUserInfo,
        showMyRankingInfoLoading: false,
      ));

      _initRankingUserInfosCountUsecase.invoke();
    });
  }

  Future<void> onRefreshMyRankingInfoClicked(BuildContext context) async {
    if (_state.value.showMyRankingInfoLoading) {
      return;
    }
    
    _state.add(_state.value.buildNew(
      showMyRankingInfoLoading: true,
    ));

    final updateResult = await _setMyRankingUserInfoUsecase.invoke();
    switch (updateResult) {
      case SetMyRankingUserInfoResult.SUCCESS:
        final myRankingInfo = await _getMyRankingUserInfoUsecase.invoke();
        _state.add(_state.value.buildNew(
          myRankingUserInfo: myRankingInfo,
        ));
        break;
      case SetMyRankingUserInfoResult.FAIL_TRY_LATER:
        delegator.showSnackBar(AppLocalizations.of(context).tryUpdateLater, const Duration(seconds: 2));
        break;
      case SetMyRankingUserInfoResult.FAIL_NO_INTERNET:
        delegator.showSnackBar(AppLocalizations.of(context).checkInternet, const Duration(seconds: 2));
        break;
      default: break;
    }

    _state.add(_state.value.buildNew(
      showMyRankingInfoLoading: false,
    ));
  }

  void onLoadMoreRankingInfosClicked() {
    // todo: show sign in dialog instead if not signed in
    _increaseRankingUserInfosCountUsecase.invoke();
  }

  void onSignInAndJoinClicked() {
    if (_state.value.showMyRankingInfoLoading) {
      return;
    }

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
    // todo: show sign in dialog instead if not signed in
    final updatedThumbedUpUids = Map.of(_state.value.thumbedUpUids);
    updatedThumbedUpUids[userInfo.uid] = true;
    _state.add(_state.value.buildNew(
      thumbedUpUids: updatedThumbedUpUids,
    ));

    _addThumbsUpUsecase.invoke(userInfo);
  }

  void dispose() {
    _rankingUserInfosEventSubscription?.cancel();
  }
}