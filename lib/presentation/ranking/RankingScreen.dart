
import 'package:flutter/material.dart';
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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Ranking Screen'),
          state.userDisplayName.isEmpty ? Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Google SignIn'),
                onPressed: () => _bloc.onGoogleSignInClicked(),
              ),
            ],
          ) : Column(
            children: <Widget>[
              Text('UserName: ${state.userDisplayName}'),
              RaisedButton(
                child: Text('Sign Out'),
                onPressed: () => _bloc.onSignOutClicked(),
              )
            ],
          ),
        ],
      ),
    );
  }
}