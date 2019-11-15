
import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/RankingUserInfo.dart';
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
    return Center(
      child: Column(
        children: <Widget>[
          Text('Ranking Screen'),
          state.userDisplayName.isEmpty ? Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Google SignIn'),
                onPressed: () => _bloc.onGoogleSignInClicked(),
              ),
              RaisedButton(
                child: Text('Facebook SignIn'),
                onPressed: () => _bloc.onFacebookSignInClicked(),
              ),
            ],
          ) : Column(
            children: <Widget>[
              Text('UserName: ${state.userDisplayName}'),
              RaisedButton(
                child: Text('Sign Out'),
                onPressed: () => _bloc.onSignOutClicked(),
              ),
              RaisedButton(
                child: Text('Submit my score'),
                onPressed: () => _bloc.onSubmitMyScoreClicked(),
              ),
            ],
          ),
          state.hasMoreRankingInfos ? RaisedButton(
            child: Text('Load more'),
            onPressed: () => _bloc.onLoadMoreRankingInfosClicked(),
          ): const SizedBox.shrink(),
          Expanded(
            child: ListView.builder(
              itemCount: state.rankingUserInfos.length,
              itemBuilder: (context, index) {
                final userInfo = state.rankingUserInfos[index];
                return _RankingItem(
                  rank: index + 1,
                  userInfo: userInfo,
                );
              },
            ),
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
    return Row(
      children: <Widget>[
        Text('$rank'),
        const SizedBox(width: 4,),
        Text('${userInfo.name}'),
        const SizedBox(width: 4,),
        Text('ratio: ${userInfo.completionRatio}'),
        const SizedBox(width: 4,),
        Text('ls: ${userInfo.latestStreak}'),
        const SizedBox(width: 4,),
        Text('ms: ${userInfo.maxStreak}'),
      ],
    );
  }
}