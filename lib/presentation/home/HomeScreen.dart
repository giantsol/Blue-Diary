
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/HomeChildScreenItem.dart';
import 'package:todo_app/presentation/home/HomeBloc.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/settings/SettingsScreen.dart';
import 'package:todo_app/presentation/week/WeekScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> implements WeekBlocDelegator,
  SettingsBlocDelegator {
  HomeBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc(context);
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

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _buildUI(HomeState state) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  _ChildScreen(
                    childScreenKey: state.currentChildScreenKey,
                    weekBlocDelegator: this,
                    settingsBlocDelegator: this,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.DIVIDER, AppColors.DIVIDER.withAlpha(0)]
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _BottomNavigationBar(
              bloc: _bloc,
              childScreenItems: state.childScreenItems,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void showBottomSheet(void Function(BuildContext) builder, {
    void Function() onClosed
  }) {
    Utils.showBottomSheet(_scaffoldKey.currentState, builder, onClosed: onClosed);
  }

  @override
  void showSnackBar(String text, Duration duration) {
    Utils.showSnackBar(_scaffoldKey.currentState, text, duration);
  }

  @override
  void addBottomNavigationItemClickedListener(void Function(String key) listener) {
    _bloc.addBottomNavigationItemClickedListener(listener);
  }

  @override
  void removeBottomNavigationItemClickedListener(void Function(String key) listener) {
    _bloc.removeBottomNavigationItemClickedListener(listener);
  }
}

class _ChildScreen extends StatelessWidget {
  final String childScreenKey;
  final WeekBlocDelegator weekBlocDelegator;
  final SettingsBlocDelegator settingsBlocDelegator;

  _ChildScreen({
    @required this.childScreenKey,
    @required this.weekBlocDelegator,
    @required this.settingsBlocDelegator,
  });

  @override
  Widget build(BuildContext context) {
    switch (childScreenKey) {
      case HomeChildScreenItem.KEY_RECORD:
        return WeekScreen(
          weekBlocDelegator: weekBlocDelegator,
        );
      case HomeChildScreenItem.KEY_SETTINGS:
        return SettingsScreen(
          settingsBlocDelegator: settingsBlocDelegator,
        );
      default:
        return Container();
    }
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final HomeBloc bloc;
  final List<HomeChildScreenItem> childScreenItems;

  _BottomNavigationBar({
    @required this.bloc,
    @required this.childScreenItems,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 55,
        ),
        color: AppColors.BACKGROUND_WHITE,
        child: Row(
          children: List.generate(childScreenItems.length, (index) {
            return _BottomNavigationItem(
              bloc: bloc,
              item: childScreenItems[index],
            );
          }),
        ),
      )
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  final HomeBloc bloc;
  final HomeChildScreenItem item;

  _BottomNavigationItem({
    @required this.bloc,
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.key == HomeChildScreenItem.KEY_RECORD ? AppLocalizations.of(context).recordNavigationTitle
      : AppLocalizations.of(context).settingsNavigationTitle;
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => bloc.onBottomNavigationItemClicked(item.key),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(item.iconPath),
                  SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: item.titleColor,
                      fontSize: 14,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
