
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/Friend.dart';
import 'package:todo_app/domain/entity/World.dart';
import 'package:todo_app/presentation/world/WorldBloc.dart';
import 'package:todo_app/presentation/world/WorldState.dart';

class WorldScreen extends StatefulWidget {
  final World world;

  WorldScreen(this.world);

  @override
  State createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  WorldBloc _bloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = WorldBloc(widget.world);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _scrollController.dispose();
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

  Widget _buildUI(WorldState state) {
    final bgPath = state.bgPath;
    final title = AppLocalizations.of(context).getWorldTitle(state.worldKey);
    final growthPainCount = state.growthPainCount;
    final friends = state.friends;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _Header(
                bgPath: bgPath,
                title: title,
                growthPainCount: growthPainCount,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return _FriendItem(
                      friend: friend,
                    );
                  },
                ),
              )
            ],
          ),
          _BackFAB(
            bloc: _bloc,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String bgPath;
  final String title;
  final int growthPainCount;

  _Header({
    @required this.bgPath,
    @required this.title,
    @required this.growthPainCount,
  });

  @override
  Widget build(BuildContext context) {
    final topStatusBarHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: <Widget>[
        Image.asset(bgPath),
        Padding(
          padding: EdgeInsets.only(top: topStatusBarHeight),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                ),
              ),
              _GrowthPainCount(
                count: growthPainCount,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GrowthPainCount extends StatelessWidget {
  final int count;

  _GrowthPainCount({
    @required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '$count',
      ),
    );
  }
}

class _BackFAB extends StatelessWidget {
  final WorldBloc bloc;

  _BackFAB({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 16,),
        child: FloatingActionButton(
          heroTag: null,
          child: Image.asset('assets/ic_back_arrow.png'),
          backgroundColor: AppColors.BACKGROUND_WHITE,
          onPressed: () => bloc.onBackFABClicked(context),
        ),
      ),
    );
  }
}

class _FriendItem extends StatelessWidget {
  final Friend friend;

  _FriendItem({
    @required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppColors.PRIMARY,
    );
  }
}

