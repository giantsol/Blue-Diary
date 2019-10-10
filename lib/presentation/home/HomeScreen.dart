
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/presentation/home/HomeBloc.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/week/WeekScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> implements WeekBlocDelegator {
  HomeBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc();
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

  Widget _buildUI(HomeState state) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _ChildScreen(
              childScreenKey: state.currentChildScreenKey,
              weekBlocDelegator: this,
            ),
            _SideMenuIcon(
              bloc: _bloc,
            ),
          ],
        ),
        endDrawer: _Drawer(
          bloc: _bloc,
          drawerItems: state.allDrawerItems,
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
  void setCurrentDrawerChildScreenItem(String key) {
    _bloc.setCurrentDrawerChildScreenItem(key);
  }

  @override
  void showSnackBar(String text, Duration duration) {
    Utils.showSnackBar(_scaffoldKey.currentState, text, duration);
  }

  @override
  void addSettingsChangedListener(listener) {
    _bloc.addSettingsChangedListener(listener);
  }

  @override
  void removeSettingsChangedListener(listener) {
    _bloc.removeSettingsChangedListener(listener);
  }
}

class _ChildScreen extends StatelessWidget {
  final String childScreenKey;
  final WeekBlocDelegator weekBlocDelegator;

  _ChildScreen({
    @required this.childScreenKey,
    @required this.weekBlocDelegator,
});

  @override
  Widget build(BuildContext context) {
    switch (childScreenKey) {
      case DrawerChildScreenItem.KEY_RECORD:
        return WeekScreen(
          weekBlocDelegator: weekBlocDelegator
        );
      default:
        throw Exception('Not existing child sreen: $childScreenKey');
    }
  }
}

class _SideMenuIcon extends StatelessWidget {
  final HomeBloc bloc;

  _SideMenuIcon({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: InkWell(
          customBorder: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Image.asset('assets/ic_side_menu.png'),
          ),
          onTap: () => bloc.onMenuIconClicked(Scaffold.of(context)),
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  final HomeBloc bloc;
  final List<DrawerItem> drawerItems;

  _Drawer({
    @required this.bloc,
    @required this.drawerItems,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: List.generate(drawerItems.length, (index) {
                    final item = drawerItems[index];
                    if (item is DrawerHeaderItem) {
                      return DrawerHeader(
                        child: Text(item.title),
                      );
                    } else if (item is DrawerChildScreenItem) {
                      return ListTile(
                        title: Text(AppLocalizations.of(context).getDrawerTitle(item.key)),
                        enabled: item.isEnabled,
                        selected: item.isSelected,
                        onTap: () => bloc.onDrawerChildScreenItemClicked(context, item),
                      );
                    } else if (item is DrawerScreenItem) {
                      return ListTile(
                        title: Text(AppLocalizations.of(context).getDrawerTitle(item.key)),
                        enabled: item.isEnabled,
                        onTap: () => bloc.onDrawerScreenItemClicked(context, item),
                      );
                    } else {
                      return Spacer();
                    }
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
