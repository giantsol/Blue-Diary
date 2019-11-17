
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/World.dart';
import 'package:todo_app/presentation/pet/PetBloc.dart';
import 'package:todo_app/presentation/pet/PetState.dart';

class PetScreen extends StatefulWidget {
  @override
  State createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  PetBloc _bloc;
  ScrollController _scrollController;
  final GlobalKey<_HeaderShadowState> _headerShadowKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = PetBloc();
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

  Widget _buildUI(PetState state) {
    return state.viewState == PetViewState.LOADING ? _WholeLoadingView()
      : Column(
      children: <Widget>[
        _Header(
          title: AppLocalizations.of(context).petTitle,
          growthPainCount: state.growthPainCount,
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: state.worlds.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final world = state.worlds[index];
                  return _WorldItem(
                    bloc: _bloc,
                    item: world,
                  );
                },
              ),
              _HeaderShadow(
                key: _headerShadowKey,
                scrollController: _scrollController,
              ),
            ],
          ),
        ),
      ],
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
  final String title;
  final int growthPainCount;

  _Header({
    @required this.title,
    @required this.growthPainCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _GrowthPainCount(
          count: growthPainCount,
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

class _HeaderShadow extends StatefulWidget {
  final ScrollController scrollController;

  _HeaderShadow({
    Key key,
    @required this.scrollController,
  }): super(key: key);

  @override
  State createState() => _HeaderShadowState();
}

class _HeaderShadowState extends State<_HeaderShadow> {
  bool _isShadowVisible = false;
  var _scrollListener;

  @override
  void initState() {
    super.initState();
    _scrollListener = () {
      try {
        updateShadowVisibility(widget.scrollController.position.pixels > 0);
      } catch (e) {
        updateShadowVisibility(false);
      }
    };
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_scrollListener);
  }

  void updateShadowVisibility(bool visible) {
    setState(() {
      _isShadowVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _isShadowVisible ? 6 : 0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.DIVIDER, AppColors.DIVIDER.withAlpha(0)]
        )
      ),
    );
  }
}

class _WorldItem extends StatelessWidget {
  final PetBloc bloc;
  final World item;

  _WorldItem({
    @required this.bloc,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final title = AppLocalizations.of(context).getWorldTitle(item.key);
    final bgPath = item.bgPath;

    return Container(
      width: 100,
      height: 100,
      child: InkWell(
        onTap: () => bloc.onWorldItemClicked(context, item),
        child: Stack(
          children: <Widget>[
            Image.asset(bgPath),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}
