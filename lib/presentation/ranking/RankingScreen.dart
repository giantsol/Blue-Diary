
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/MyRankingUserInfoState.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/presentation/ranking/RankingBloc.dart';
import 'package:todo_app/presentation/ranking/RankingState.dart';
import 'package:todo_app/presentation/widgets/AppTextField.dart';

class RankingScreen extends StatefulWidget {
  final RankingBlocDelegator rankingBlocDelegator;

  RankingScreen({
    @required this.rankingBlocDelegator,
  });

  @override
  State createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  RankingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RankingBloc();
    _bloc.updateDelegator(widget.rankingBlocDelegator);
  }

  @override
  void didUpdateWidget(RankingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.updateDelegator(widget.rankingBlocDelegator);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  Widget _buildUI(RankingState state) {
    final thumbedUpUids = state.thumbedUpUids;

    return WillPopScope(
      onWillPop: () async => !_bloc.handleBackPress(),
      child: Stack(
        children: <Widget>[
          state.viewState == RankingViewState.LOADING ? _WholeLoadingView()
            : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Header(
                bloc: _bloc,
                myRankingInfoState: state.myRankingUserInfoState,
                showOverlayProgress: state.showMyRankingInfoLoading,
                isEditingDisplayName: state.isEditingDisplayName,
                displayNameEditorText: state.displayNameEditorText,
              ),
              const SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Text(
                  AppLocalizations.of(context).ranking,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.TEXT_BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 8, right: 24,),
                  child: state.isRankingUserInfosLoading ? Center(
                    child: CircularProgressIndicator(),
                  ) : state.rankingUserInfos.length == 0 ? Center(
                    child: Text(
                      AppLocalizations.of(context).noRankingUserInfos,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.TEXT_BLACK,
                      ),
                    ),
                  ) : ListView.builder(
                    itemCount: state.hasMoreRankingInfos ? state.rankingUserInfos.length + 1 : state.rankingUserInfos.length,
                    itemBuilder: (context, index) {
                      if (index <= state.rankingUserInfos.length - 1) {
                        final userInfo = state.rankingUserInfos[index];
                        return _RankingItem(
                          bloc: _bloc,
                          userInfo: userInfo,
                          hasThumbedUp: thumbedUpUids.containsKey(userInfo.uid) ? true : false,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4,),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => _bloc.onLoadMoreRankingInfosClicked(context),
                            child: SizedBox(
                              height: 36,
                              child: Center(
                                child: Text(
                                  'Load more',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.TEXT_BLACK,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _WholeLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BACKGROUND_WHITE,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}

class _Header extends StatelessWidget {
  final RankingBloc bloc;
  final MyRankingUserInfoState myRankingInfoState;
  final bool showOverlayProgress;
  final bool isEditingDisplayName;
  final String displayNameEditorText;

  _Header({
    @required this.bloc,
    @required this.myRankingInfoState,
    @required this.showOverlayProgress,
    @required this.isEditingDisplayName,
    @required this.displayNameEditorText,
  });

  @override
  Widget build(BuildContext context) {
    final info = myRankingInfoState.data;
    final petPhase = info.petPhase;
    final double petMaxSize = 72;

    final latestStreakStartDate = info.latestStreakStartDate;
    final latestStreakEndDate = info.latestStreakEndDate;
    String latestStreakDateRangeText = '';
    if (latestStreakStartDate != DateRepository.INVALID_DATE && latestStreakEndDate != DateRepository.INVALID_DATE) {
      latestStreakDateRangeText = '${latestStreakStartDate.year}.${latestStreakStartDate.month}.${latestStreakStartDate.day} - ${latestStreakEndDate.year}.${latestStreakEndDate.month}.${latestStreakEndDate.day}';
    }

    final longestStreakStartDate = info.longestStreakStartDate;
    final longestStreakEndDate = info.longestStreakEndDate;
    String longestStreakDateRangeText = '';
    if (longestStreakStartDate != DateRepository.INVALID_DATE && longestStreakEndDate != DateRepository.INVALID_DATE) {
      longestStreakDateRangeText = '${longestStreakStartDate.year}.${longestStreakStartDate.month}.${longestStreakStartDate.day} - ${longestStreakEndDate.year}.${longestStreakEndDate.month}.${longestStreakEndDate.day}';
    }

    return !myRankingInfoState.isSignedIn ? InkWell(
      onTap: () => bloc.onSignInClicked(context),
      child: Container(
        height: 132,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).signIn,
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.TEXT_BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                  strutStyle: StrutStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).signInSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.TEXT_BLACK,
                  ),
                  strutStyle: StrutStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            showOverlayProgress ? CircularProgressIndicator() : const SizedBox.shrink(),
          ],
        ),
      ),
    ) : (info.isValid ? Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 56,
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 24,),
                  !isEditingDisplayName ? Expanded(
                    child: GestureDetector(
                      onTap: () => bloc.onEditDisplayNameClicked(),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/ic_edit.png'),
                          ),
                          Expanded(
                            child: Text(
                              info.name,
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.TEXT_BLACK,
                              ),
                              strutStyle: StrutStyle(
                                fontSize: 24,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            text: displayNameEditorText,
                            textSize: 24,
                            textColor: AppColors.TEXT_BLACK,
                            hintText: AppLocalizations.of(context).editDisplayNameHint,
                            hintTextSize: 24,
                            hintColor: AppColors.TEXT_BLACK_LIGHT,
                            onChanged: (s) => bloc.onDisplayNameEditorTextChanged(s),
                            maxLines: 1,
                            autoFocus: true,
                            onEditingComplete: () => bloc.onConfirmEditDisplayNameClicked(context),
                          ),
                        ),
                        InkWell(
                          onTap: () => bloc.onCancelEditDisplayNameClicked(),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              AppLocalizations.of(context).cancel,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.SECONDARY,
                              ),
                              strutStyle: StrutStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => bloc.onConfirmEditDisplayNameClicked(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              AppLocalizations.of(context).ok,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.PRIMARY,
                              ),
                              strutStyle: StrutStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8,),
                  InkWell(
                    onTap: () => bloc.onSignOutClicked(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                      child: Text(
                        AppLocalizations.of(context).signOut,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.TEXT_BLACK,
                          fontWeight: FontWeight.bold,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 14,
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24,),
              child: Row(
                children: <Widget>[
                  Container(
                    width: petMaxSize,
                    height: petMaxSize,
                    child: petPhase != PetPhase.INVALID ? Align(
                      alignment: petPhase.alignment,
                      child: SizedBox(
                        width: petMaxSize * petPhase.sizeRatio,
                        height: petMaxSize * petPhase.sizeRatio,
                        child: FlareActor(
                          petPhase.flrPath,
                          animation: petPhase.idleAnimName,
                        ),
                      ),
                    ): Container(
                      width: petMaxSize,
                      height: petMaxSize,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).noPet,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.TEXT_BLACK,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).completedDays,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.TEXT_BLACK,
                          ),
                        ),
                        RichText(
                          textScaleFactor: MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.TEXT_BLACK,
                            ),
                            children: [
                              TextSpan(
                                text: info.completionRatioPercentageString,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: AppColors.PRIMARY,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' %'
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).currentStreak,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.TEXT_BLACK,
                        ),
                      ),
                      RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.TEXT_BLACK_LIGHT,
                          ),
                          children: [
                            TextSpan(
                              text: '${info.latestStreak}',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.PRIMARY,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '  $latestStreakDateRangeText',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4,),
                      Text(
                        AppLocalizations.of(context).longestStreak,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.TEXT_BLACK,
                        ),
                      ),
                      RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.TEXT_BLACK_LIGHT,
                          ),
                          children: [
                            TextSpan(
                              text: '${info.longestStreak}',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.PRIMARY,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '  $longestStreakDateRangeText',
                            ),
                          ],
                        ),
                      ),
//                      const SizedBox(height: 4,),
//                      Text(
//                        AppLocalizations.of(context).thumbsUp,
//                        style: TextStyle(
//                          fontSize: 10,
//                          color: AppColors.TEXT_BLACK,
//                        ),
//                      ),
//                      Text(
//                        '${info.thumbUpCount}',
//                        style: TextStyle(
//                          fontSize: 18,
//                          color: AppColors.PRIMARY,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24,),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => bloc.onRefreshMyRankingInfoClicked(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Last updated: ${Utils.toLastUpdatedFormat(DateTime.fromMillisecondsSinceEpoch(info.lastUpdatedMillis))}',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.TEXT_BLACK,
                        ),
                      ),
                      const SizedBox(width: 4,),
                      Image.asset('assets/ic_refresh.png'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        showOverlayProgress ? Center(
          child: CircularProgressIndicator(),
        ) : const SizedBox.shrink(),
      ],
    ) : GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => bloc.onReloadMyRankingUserInfoClicked(),
      child: Container(
        height: 132,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).reload,
              style: TextStyle(
                fontSize: 24,
                color: AppColors.TEXT_BLACK,
                fontWeight: FontWeight.bold,
              ),
            ),
            showOverlayProgress ? CircularProgressIndicator() : const SizedBox.shrink(),
          ],
        ),
      ),
    ));
  }
}

class _RankingItem extends StatelessWidget {
  final RankingBloc bloc;
  final RankingUserInfo userInfo;
  final bool hasThumbedUp;

  const _RankingItem({
    @required this.bloc,
    @required this.userInfo,
    @required this.hasThumbedUp,
  });

  @override
  Widget build(BuildContext context) {
    final petPhase = userInfo.petPhase;
    final rank = userInfo.rank;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4,),
      child: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 20,),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: rank == 1 ? AppColors.GOLD
                    : rank == 2 ? AppColors.SILVER
                    : rank == 3 ? AppColors.BRONZE
                    : AppColors.TEXT_BLACK,
                  fontSize: 14,
                ),
              ),
            )
          ),
          const SizedBox(width: 8,),
          SizedBox(
            width: 36,
            height: 36,
            child: petPhase != PetPhase.INVALID ? FlareActor(
              petPhase.flrPath,
            ) : userInfo.petKey.isEmpty ? Center(
              child: Text(
                AppLocalizations.of(context).noPet,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.TEXT_BLACK,
                ),
                textAlign: TextAlign.center,
              ),
            ) : Center(
              child: Text(
                AppLocalizations.of(context).needUpdate,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.TEXT_BLACK,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userInfo.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.TEXT_BLACK,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${userInfo.latestStreak} streak',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.TEXT_BLACK_LIGHT,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 8,),
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              style: TextStyle(
                fontSize: 10,
                color: AppColors.TEXT_BLACK,
              ),
              children: [
                TextSpan(
                  text: userInfo.completionRatioPercentageString,
                  style: TextStyle(
                    fontSize: 20,
                    color: rank == 1 ? AppColors.GOLD
                      : rank == 2 ? AppColors.SILVER
                      : rank == 3 ? AppColors.BRONZE
                      : AppColors.TEXT_BLACK,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' %'
                ),
              ],
            ),
          ),
//          const SizedBox(width: 8,),
//          GestureDetector(
//            behavior: HitTestBehavior.translucent,
//            onTap: hasThumbedUp ? null : () => bloc.onThumbUpClicked(context, userInfo),
//            child: Padding(
//              padding: const EdgeInsets.symmetric(vertical: 8,),
//              child: Row(
//                children: <Widget>[
//                  Image.asset(hasThumbedUp ? 'assets/ic_thumbs_up_activated.png' : 'assets/ic_thumbs_up.png'),
//                  const SizedBox(width: 4,),
//                  ConstrainedBox(
//                    constraints: BoxConstraints(minWidth: 22),
//                    child: Text(
//                      userInfo.thumbUpCount.toString(),
//                      style: TextStyle(
//                        fontSize: 12,
//                        color: AppColors.TEXT_BLACK,
//                      ),
//                      textAlign: TextAlign.left,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
