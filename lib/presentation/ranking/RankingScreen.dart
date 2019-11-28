
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/presentation/ranking/RankingBloc.dart';
import 'package:todo_app/presentation/ranking/RankingState.dart';

class RankingScreen extends StatefulWidget {
  @override
  State createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  RankingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RankingBloc();
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
                myRankingInfo: state.myRankingInfo,
              ),
              const SizedBox(height: 20,),
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
                  child: ListView.builder(
                    itemCount: state.hasMoreRankingInfos ? state.rankingUserInfos.length + 1 : state.rankingUserInfos.length,
                    itemBuilder: (context, index) {
                      if (index <= state.rankingUserInfos.length - 1) {
                        final userInfo = state.rankingUserInfos[index];
                        return _RankingItem(
                          rank: index + 1,
                          userInfo: userInfo,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4,),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => _bloc.onLoadMoreRankingInfosClicked(),
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
          state.signInDialogShown ? _SignInDialog(
            bloc: _bloc,
          ) : const SizedBox.shrink(),
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
  final RankingUserInfo myRankingInfo;

  _Header({
    @required this.bloc,
    @required this.myRankingInfo,
  });

  @override
  Widget build(BuildContext context) {
    final petPhase = myRankingInfo.petPhase;
    final double petMaxSize = 72;

    final latestStreakStartDate = myRankingInfo.latestStreakStartDate;
    final latestStreakEndDate = myRankingInfo.latestStreakEndDate;
    String latestStreakDateRangeText = '';
    if (latestStreakStartDate != DateRepository.INVALID_DATE && latestStreakEndDate != DateRepository.INVALID_DATE) {
      latestStreakDateRangeText = '${latestStreakStartDate.year}.${latestStreakStartDate.month}.${latestStreakStartDate.day} - ${latestStreakEndDate.year}.${latestStreakEndDate.month}.${latestStreakEndDate.day}';
    }

    final longestStreakStartDate = myRankingInfo.longestStreakStartDate;
    final longestStreakEndDate = myRankingInfo.longestStreakEndDate;
    String longestStreakDateRangeText = '';
    if (longestStreakStartDate != DateRepository.INVALID_DATE && longestStreakEndDate != DateRepository.INVALID_DATE) {
      longestStreakDateRangeText = '${longestStreakStartDate.year}.${longestStreakStartDate.month}.${longestStreakStartDate.day} - ${longestStreakEndDate.year}.${longestStreakEndDate.month}.${longestStreakEndDate.day}';
    }

    return myRankingInfo == RankingUserInfo.INVALID ? GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => bloc.onSignInAndJoinClicked(),
      child: Container(
        height: 132,
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context).clickToSignInAndJoin,
        ),
      ),
    ) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 56,
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  myRankingInfo.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.TEXT_BLACK,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => bloc.onSignOutClicked(),
                  child: Image.asset('assets/ic_back_arrow.png'),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width: petMaxSize,
                height: petMaxSize,
                child: petPhase != PetPhase.INVALID ? Align(
                  alignment: petPhase.alignment,
                  child: SizedBox(
                    width: petMaxSize * petPhase.sizeRatio,
                    height: petMaxSize * petPhase.sizeRatio,
                    //todo: change to flare
                    child: Image.asset(
                      petPhase.imgPath,
                      fit: BoxFit.fill,
                    ),
                  ),
                ): const SizedBox.shrink(), // todo: show something else
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
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.TEXT_BLACK,
                        ),
                        children: [
                          TextSpan(
                            text: myRankingInfo.completionRatioPercentageString,
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.PRIMARY,
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
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.TEXT_BLACK_LIGHT,
                      ),
                      children: [
                        TextSpan(
                          text: '${myRankingInfo.latestStreak}',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.PRIMARY,
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
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.TEXT_BLACK_LIGHT,
                      ),
                      children: [
                        TextSpan(
                          text: '${myRankingInfo.longestStreak}',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.PRIMARY,
                          ),
                        ),
                        TextSpan(
                          text: '  $longestStreakDateRangeText',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    AppLocalizations.of(context).thumbsUp,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.TEXT_BLACK,
                    ),
                  ),
                  Text(
                    '${myRankingInfo.thumbsUp}',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.PRIMARY,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Last updated: ${DateTime.fromMillisecondsSinceEpoch(myRankingInfo.lastUpdatedMillis)}',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.TEXT_BLACK,
                ),
              ),
              InkWell(
                onTap: () => bloc.onRefreshMyRankingInfoClicked(),
                child: Image.asset('assets/ic_back_arrow.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankingItem extends StatelessWidget {
  final int rank;
  final RankingUserInfo userInfo;

  const _RankingItem({
    @required this.rank,
    @required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    final petPhase = userInfo.petPhase;

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
            child: petPhase != PetPhase.INVALID ? Image.asset(
              petPhase.imgPath,
              fit: BoxFit.fill,
            ) : const SizedBox.shrink(), // todo: show something else
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
                  ),
                ),
                TextSpan(
                  text: ' %'
                ),
              ],
            ),
          ),
          const SizedBox(width: 8,),
          Image.asset('assets/ic_next.png'),
          const SizedBox(width: 4,),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 22),
            child: Text(
              userInfo.thumbsUp.toString(),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.TEXT_BLACK,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInDialog extends StatelessWidget {
  final RankingBloc bloc;

  _SignInDialog({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => bloc.onDismissSignInDialogClicked(),
      child: Container(
        color: AppColors.SCRIM,
        alignment: Alignment.center,
        child: Container(
          color: AppColors.BACKGROUND_WHITE,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text('Google SignIn'),
                onPressed: () => bloc.onGoogleSignInClicked(),
              ),
              FlatButton(
                child: Text('Facebook SignIn'),
                onPressed: () => bloc.onFacebookSignInClicked(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}