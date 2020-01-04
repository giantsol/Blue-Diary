
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/usecase/AddThumbsUpUsecase.dart';
import 'package:todo_app/domain/usecase/CancelThumbsUpUsecase.dart';
import 'package:todo_app/domain/usecase/GetHasThumbedUpUidUsecase.dart';
import 'package:todo_app/domain/usecase/GetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';
import 'package:todo_app/domain/usecase/IncreaseRankingUserInfosCountUsecase.dart';
import 'package:todo_app/domain/usecase/InitRankingUserInfosCountUsecase.dart';
import 'package:todo_app/domain/usecase/IsSignedInUsecase.dart';
import 'package:todo_app/domain/usecase/ObserveRankingUserInfosUsecase.dart';
import 'package:todo_app/domain/usecase/SetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SignInWithFacebookUsecase.dart';
import 'package:todo_app/domain/usecase/SignInWithGoogleUsecase.dart';
import 'package:todo_app/domain/usecase/SignOutUsecase.dart';
import 'package:todo_app/domain/usecase/SyncTodayWithServerUsecase.dart';
import 'package:todo_app/domain/usecase/UpdateRankingUserInfosCompletionRatioUsecase.dart';
import 'package:todo_app/presentation/ranking/RankingState.dart';

class RankingBloc {
  final _state = BehaviorSubject<RankingState>.seeded(RankingState());
  RankingState getInitialState() => _state.value;
  Stream<RankingState> observeState() => _state.distinct();

  RankingBlocDelegator delegator;

  StreamSubscription _rankingUserInfosEventSubscription;

  // todo: should move this to state and invoke setState immediately to prevent further clicks
  bool isThumbLogicRunning = false;

  final _getMyRankingUserInfoUsecase = GetMyRankingUserInfoStateUsecase();
  final _observeRankingUserInfosUsecase = ObserveRankingUserInfosUsecase();
  final _initRankingUserInfosCountUsecase = InitRankingUserInfosCountUsecase();
  final _setMyRankingUserInfoUsecase = SetMyRankingUserInfoUsecase();
  final _signInWithGoogleUsecase = SignInWithGoogleUsecase();
  final _signInWithFacebookUsecase = SignInWithFacebookUsecase();
  final _signOutUsecase = SignOutUsecase();
  final _increaseRankingUserInfosCountUsecase = IncreaseRankingUserInfosCountUsecase();
  final _cancelThumbsUpUsecase = CancelThumbsUpUsecase();
  final _addThumbUpUsecase = AddThumbUpUsecase();
  final _getHasThumbedUpUidUsecase = GetHasThumbedUpUidUsecase();
  final _getTodayUsecase = GetTodayUsecase();
  final _syncTodayWithServerUsecase = SyncTodayWithServerUsecase();
  final _isSignedInUsecase = IsSignedInUsecase();
  final _updateRankingUserInfosCompletionRatioUsecase = UpdateRankingUserInfosCompletionRatioUsecase();

  RankingBloc() {
    _initState();
  }

  void updateDelegator(RankingBlocDelegator delegator) {
    this.delegator = delegator;
  }

  Future<void> _initState() async {
    final myRankingInfoState = await _getMyRankingUserInfoUsecase.invoke();

    _state.add(_state.value.buildNew(
      viewState: RankingViewState.NORMAL,
      myRankingUserInfoState: myRankingInfoState,
    ));

    _rankingUserInfosEventSubscription = _observeRankingUserInfosUsecase.invoke()
      .listen((event) async {
        final updatedThumbedUpUids = Map.of(_state.value.thumbedUpUids);
        for (final rankingUserInfo in event.rankingUserInfos) {
          final hasThumbedUp = await _getHasThumbedUpUidUsecase.invoke(rankingUserInfo.uid);
          if (hasThumbedUp) {
            updatedThumbedUpUids[rankingUserInfo.uid] = true;
          } else {
            updatedThumbedUpUids.remove(rankingUserInfo.uid);
          }
        }
      _state.add(_state.value.buildNew(
        rankingUserInfos: event.rankingUserInfos,
        hasMoreRankingInfos: event.hasMore,
        isRankingUserInfosLoading: false,
        thumbedUpUids: updatedThumbedUpUids,
      ));

      final isSignedIn = await _isSignedInUsecase.invoke();
      if (isSignedIn) {
        final todaySyncedSuccessful = await _syncTodayWithServerUsecase.invoke();
        if (todaySyncedSuccessful) {
          final today = await _getTodayUsecase.invoke();
          if (today != DateRepository.INVALID_DATE) {
            final List<RankingUserInfo> updateNeededRankingUserInfos = [];

            event.rankingUserInfos.forEach((it) {
              final firstLaunchDate = it.firstLaunchDateMillis != 0 ? DateTime.fromMillisecondsSinceEpoch(it.firstLaunchDateMillis)
                : DateRepository.INVALID_DATE;
              if (firstLaunchDate != DateRepository.INVALID_DATE) {
                final totalDaysCount = today.difference(firstLaunchDate).inDays + 1;
                final completedDaysCount = it.completedDaysCount;
                final double completionRatio = totalDaysCount > 0 ? completedDaysCount / totalDaysCount : 0;

                if (it.completionRatio != completionRatio) {
                  final updated = it.buildNew(completionRatio: completionRatio);
                  // todo: remove debugPrint
                  debugPrint('updating completion ratio of id: ${updated.uid}');
                  updateNeededRankingUserInfos.add(updated);
                }
              }
            });

            if (updateNeededRankingUserInfos.isNotEmpty) {
              _updateRankingUserInfosCompletionRatioUsecase.invoke(updateNeededRankingUserInfos);
            }
          }
        }
      }
    });

    _initRankingUserInfosCountUsecase.invoke();
  }

  Future<void> onGoogleSignInClicked(BuildContext context) async {
    final errorSigningInText = AppLocalizations.of(context).errorSigningIn;

    _state.add(_state.value.buildNew(
      signInDialogShown: false,
      showMyRankingInfoLoading: true,
    ));

    final myRankingUserInfo = await _signInWithGoogleUsecase.invoke();
    if (!myRankingUserInfo.isSignedIn) {
      delegator.showSnackBar(errorSigningInText, const Duration(seconds: 2));
    }

    _state.add(_state.value.buildNew(
      myRankingUserInfoState: myRankingUserInfo,
      showMyRankingInfoLoading: false,
    ));
  }

  Future<void> onFacebookSignInClicked(BuildContext context) async {
    final errorSigningInText = AppLocalizations.of(context).errorSigningIn;

    _state.add(_state.value.buildNew(
      signInDialogShown: false,
      showMyRankingInfoLoading: true,
    ));

    final myRankingUserInfo = await _signInWithFacebookUsecase.invoke();
    if (!myRankingUserInfo.isSignedIn) {
      delegator.showSnackBar(errorSigningInText, const Duration(seconds: 2));
    }

    _state.add(_state.value.buildNew(
      myRankingUserInfoState: myRankingUserInfo,
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

      final signOutSuccess = await _signOutUsecase.invoke();
      if (signOutSuccess) {
        final myRankingUserInfoState = await _getMyRankingUserInfoUsecase.invoke();
        _state.add(_state.value.buildNew(
          myRankingUserInfoState: myRankingUserInfoState,
          showMyRankingInfoLoading: false,
        ));

        _initRankingUserInfosCountUsecase.invoke();
      } else {
        final errorSigningOutText = AppLocalizations.of(context).errorSigningOut;
        delegator.showSnackBar(errorSigningOutText, const Duration(seconds: 2));

        _state.add(_state.value.buildNew(
          showMyRankingInfoLoading: false,
        ));
      }
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
        final myRankingInfoState = await _getMyRankingUserInfoUsecase.invoke();
        _state.add(_state.value.buildNew(
          myRankingUserInfoState: myRankingInfoState,
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

  Future<void> onLoadMoreRankingInfosClicked() async {
    final isSignedIn = await _isSignedInUsecase.invoke();
    if (!isSignedIn) {
      _state.add(_state.value.buildNew(
        signInDialogShown: true,
      ));
    } else {
      _increaseRankingUserInfosCountUsecase.invoke();
    }
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

  Future<void> onCancelThumbsUpClicked(RankingUserInfo userInfo) async {
    if (isThumbLogicRunning) {
      return;
    }

    isThumbLogicRunning = true;
    final isSignedIn = await _isSignedInUsecase.invoke();
    if (!isSignedIn) {
      _state.add(_state.value.buildNew(
        signInDialogShown: true,
      ));
      isThumbLogicRunning = false;
    } else {
      await _cancelThumbsUpUsecase.invoke(userInfo.uid);
      isThumbLogicRunning = false;
    }
  }

  Future<void> onThumbsUpClicked(RankingUserInfo userInfo) async {
    if (isThumbLogicRunning) {
      return;
    }

    isThumbLogicRunning = true;
    final isSignedIn = await _isSignedInUsecase.invoke();
    if (!isSignedIn) {
      _state.add(_state.value.buildNew(
        signInDialogShown: true,
      ));
      isThumbLogicRunning = false;
    } else {
      await _addThumbUpUsecase.invoke(userInfo.uid);
      isThumbLogicRunning = false;
    }
  }

  Future<void> onReloadMyRankingUserInfoClicked() async {
    if (_state.value.showMyRankingInfoLoading) {
      return;
    }

    _state.add(_state.value.buildNew(
      showMyRankingInfoLoading: true,
    ));

    final myRankingUserInfoState = await _getMyRankingUserInfoUsecase.invoke();
    _state.add(_state.value.buildNew(
      showMyRankingInfoLoading: false,
      myRankingUserInfoState: myRankingUserInfoState,
    ));
  }

  void dispose() {
    _rankingUserInfosEventSubscription?.cancel();
  }
}