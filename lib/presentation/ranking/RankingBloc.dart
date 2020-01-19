
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
import 'package:todo_app/domain/usecase/IsSignedInUsecase.dart';
import 'package:todo_app/domain/usecase/ObserveRankingUserInfosUsecase.dart';
import 'package:todo_app/domain/usecase/SetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SetUserDisplayNameUsecase.dart';
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

  // Temporarily need this.. because of transaction
  // https://github.com/giantsol/Blue-Diary/issues/148
  bool _isThumbingUp = false;

  final Map<String, bool> completionRatioUpdatedUids = {};

  final _getMyRankingUserInfoUsecase = GetMyRankingUserInfoStateUsecase();
  final _observeRankingUserInfosUsecase = ObserveRankingUserInfosUsecase();
  final _initRankingUserInfosCountUsecase = InitRankingUserInfosCountUsecase();
  final _setMyRankingUserInfoUsecase = SetMyRankingUserInfoUsecase();
  final _signInWithGoogleUsecase = SignInWithGoogleUsecase();
  final _signOutUsecase = SignOutUsecase();
  final _increaseRankingUserInfosCountUsecase = IncreaseRankingUserInfosCountUsecase();
  final _addThumbUpUsecase = AddThumbUpUsecase();
  final _getTodayUsecase = GetTodayUsecase();
  final _syncTodayWithServerUsecase = SyncTodayWithServerUsecase();
  final _isSignedInUsecase = IsSignedInUsecase();
  final _updateRankingUserInfosCompletionRatioUsecase = UpdateRankingUserInfosCompletionRatioUsecase();
  final _setUserDisplayNameUsecase = SetUserDisplayNameUsecase();

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
//      final updatedThumbedUpUids = Map.of(_state.value.thumbedUpUids);
//      for (final rankingUserInfo in event.rankingUserInfos) {
//        final hasThumbedUp = await _getHasThumbedUpUidUsecase.invoke(rankingUserInfo.uid);
//        final uid = rankingUserInfo.uid;
//        if (hasThumbedUp) {
//          if (rankingUserInfo.thumbUpCount == 0) {
//            updatedThumbedUpUids.remove(uid);
//            _removeThumbedUpUsecase.invoke(uid);
//          } else {
//            updatedThumbedUpUids[uid] = true;
//          }
//        }
//      }

      _state.add(_state.value.buildNew(
        rankingUserInfos: event.rankingUserInfos,
        hasMoreRankingInfos: event.hasMore,
        isRankingUserInfosLoading: false,
//        thumbedUpUids: updatedThumbedUpUids,
      ));

      final isSignedIn = await _isSignedInUsecase.invoke();
      if (isSignedIn) {
        final todaySyncedSuccessful = await _syncTodayWithServerUsecase.invoke();
        if (todaySyncedSuccessful) {
          final today = await _getTodayUsecase.invoke();
          if (today != DateRepository.INVALID_DATE) {
            final List<RankingUserInfo> updateNeededRankingUserInfos = [];

            event.rankingUserInfos.forEach((it) {
              if (it.uid == myRankingInfoState.data.uid || completionRatioUpdatedUids.containsKey(it.uid)) {
                return;
              }

              final firstLaunchDate = it.firstLaunchDateMillis != 0 ? DateTime.fromMillisecondsSinceEpoch(it.firstLaunchDateMillis)
                : DateRepository.INVALID_DATE;
              if (firstLaunchDate != DateRepository.INVALID_DATE) {
                final beforeTodayDaysCount = today.difference(firstLaunchDate).inDays;
                final completedDaysCount = it.completedDaysCount;
                final double completionRatio = completedDaysCount > beforeTodayDaysCount ? 1
                  : beforeTodayDaysCount > 0 ? completedDaysCount / beforeTodayDaysCount : 0;

                if (it.completionRatio.toStringAsFixed(4) != completionRatio.toStringAsFixed(4)) {
                  final updated = it.buildNew(completionRatio: completionRatio);
                  updateNeededRankingUserInfos.add(updated);
                }
              }
            });

            if (updateNeededRankingUserInfos.isNotEmpty) {
              completionRatioUpdatedUids.addEntries(updateNeededRankingUserInfos.map((it) => MapEntry(it.uid, true)));
              _updateRankingUserInfosCompletionRatioUsecase.invoke(updateNeededRankingUserInfos);
            }
          }
        }
      }
    });

    _initRankingUserInfosCountUsecase.invoke();
  }

//  Future<void> onFacebookSignInClicked(BuildContext context) async {
//    final errorSigningInText = AppLocalizations.of(context).errorSigningIn;
//
//    _state.add(_state.value.buildNew(
//      signInDialogShown: false,
//      showMyRankingInfoLoading: true,
//    ));
//
//    final myRankingUserInfo = await _signInWithFacebookUsecase.invoke();
//    if (!myRankingUserInfo.isSignedIn) {
//      delegator.showSnackBar(errorSigningInText, const Duration(seconds: 2));
//    }
//
//    _state.add(_state.value.buildNew(
//      myRankingUserInfoState: myRankingUserInfo,
//      showMyRankingInfoLoading: false,
//    ));
//  }

  void onSignOutClicked(BuildContext context) {
    if (_state.value.showMyRankingInfoLoading) {
      return;
    }

    final title = AppLocalizations.of(context).signOutTitle;
    final body = AppLocalizations.of(context).signOutBody;
    Utils.showAppDialog(context, title, body, null, () async {
      _state.add(_state.value.buildNew(
        showMyRankingInfoLoading: true,
        isEditingDisplayName: false,
        displayNameEditorText: '',
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
      isEditingDisplayName: false,
      displayNameEditorText: '',
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

  Future<void> onLoadMoreRankingInfosClicked(BuildContext context) async {
    final isSignedIn = await _isSignedInUsecase.invoke();
    if (!isSignedIn) {
      onSignInClicked(context);
    } else {
      _increaseRankingUserInfosCountUsecase.invoke();
    }
  }

  Future<void> onSignInClicked(BuildContext context) async {
    if (_state.value.showMyRankingInfoLoading) {
      return;
    }

    final errorSigningInText = AppLocalizations.of(context).errorSigningIn;

    _state.add(_state.value.buildNew(
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

  bool handleBackPress() {
    if (_state.value.isEditingDisplayName) {
      _state.add(_state.value.buildNew(
        isEditingDisplayName: false,
        displayNameEditorText: '',
      ));
      return true;
    }

    return false;
  }

  Future<void> onThumbUpClicked(BuildContext context, RankingUserInfo userInfo) async {
    final isSignedIn = await _isSignedInUsecase.invoke();
    if (!isSignedIn) {
      onSignInClicked(context);
    } else {
      if (_isThumbingUp) {
        return;
      } else {
        _isThumbingUp = true;
        await _addThumbUpUsecase.invoke(userInfo.uid);
        _isThumbingUp = false;
      }
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

  void onEditDisplayNameClicked() {
    if (_state.value.showMyRankingInfoLoading) {
      return;
    }

    _state.add(_state.value.buildNew(
      isEditingDisplayName: true,
      displayNameEditorText: _state.value.myRankingUserInfoState.data.name,
    ));
  }

  void onDisplayNameEditorTextChanged(String text) {
    _state.add(_state.value.buildNew(
      displayNameEditorText: text,
    ));
  }

  void onCancelEditDisplayNameClicked() {
    _state.add(_state.value.buildNew(
      isEditingDisplayName: false,
      displayNameEditorText: '',
    ));
  }

  Future<void> onConfirmEditDisplayNameClicked(BuildContext context) async {
    final myRankingUserInfoState = _state.value.myRankingUserInfoState;
    final uid = myRankingUserInfoState.data.uid;
    final prevName = myRankingUserInfoState.data.name;
    final newName = _state.value.displayNameEditorText;
    final isMyRankingInfoLoading = _state.value.showMyRankingInfoLoading;
    if (uid.isEmpty || newName.isEmpty || isMyRankingInfoLoading || prevName == newName) {
      _state.add(_state.value.buildNew(
        isEditingDisplayName: false,
        displayNameEditorText: '',
      ));
      return;
    }

    final checkInternet = AppLocalizations.of(context).checkInternet;
    final tryUpdateLater = AppLocalizations.of(context).tryUpdateLater;

    _state.add(_state.value.buildNew(
      showMyRankingInfoLoading: true,
      isEditingDisplayName: false,
      displayNameEditorText: '',
    ));

    final nameUpdateSuccessful = await _setUserDisplayNameUsecase.invoke(uid, newName);
    if (!nameUpdateSuccessful) {
      _state.add(_state.value.buildNew(
        showMyRankingInfoLoading: false,
      ));
      delegator.showSnackBar(checkInternet, const Duration(seconds: 2));
      return;
    }

    final updateResult = await _setMyRankingUserInfoUsecase.invoke();
    switch (updateResult) {
      case SetMyRankingUserInfoResult.SUCCESS:
        final myRankingInfoState = await _getMyRankingUserInfoUsecase.invoke();
        _state.add(_state.value.buildNew(
          myRankingUserInfoState: myRankingInfoState,
        ));
        break;
      case SetMyRankingUserInfoResult.FAIL_TRY_LATER:
        await _setUserDisplayNameUsecase.invoke(uid, prevName);
        delegator.showSnackBar(tryUpdateLater, const Duration(seconds: 2));
        break;
      case SetMyRankingUserInfoResult.FAIL_NO_INTERNET:
        await _setUserDisplayNameUsecase.invoke(uid, prevName);
        delegator.showSnackBar(checkInternet, const Duration(seconds: 2));
        break;
      default: break;
    }

    _state.add(_state.value.buildNew(
      showMyRankingInfoLoading: false,
    ));
  }

  void dispose() {
    _rankingUserInfosEventSubscription?.cancel();
  }
}