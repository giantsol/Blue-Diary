
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/pet/PetBloc.dart';
import 'package:todo_app/presentation/pet/PetState.dart';

class PetScreen extends StatefulWidget {
  @override
  State createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  PetBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PetBloc();
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
