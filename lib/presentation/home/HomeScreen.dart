
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/presentation/home/HomeBloc.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/home/calendar/CalendarScreen.dart';
import 'package:todo_app/presentation/week/WeekScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();
    _bloc = HomeBloc();
  }

  @override
  dispose() {
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
            _buildChildScreen(state),
            _buildSideMenuIcon(),
          ],
        ),
        endDrawer: _buildDrawer(state),
      ),
    );
  }

  Widget _buildChildScreen(HomeState state) {
    final childScreenKey = state.currentChildScreenKey;
    switch (childScreenKey) {
      case DrawerChildScreenItem.KEY_WEEK:
        return WeekScreen(weekBlocDelegator: _bloc);
      case DrawerChildScreenItem.KEY_CALENDAR:
        return CalendarScreen();
      default:
        throw Exception('Not existing child sreen: $childScreenKey');
    }
  }

  Widget _buildSideMenuIcon() {
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
          onTap: () => _bloc.onMenuIconClicked(_scaffoldKey.currentState),
        ),
      ),
    );
  }

  Widget _buildDrawer(HomeState state) {
    final drawerItems = state.allDrawerItems;
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
                        title: Text(item.title),
                        enabled: item.isEnabled,
                        selected: item.isSelected,
                        onTap: () => _bloc.onDrawerChildScreenItemClicked(context, item),
                      );
                    } else if (item is DrawerScreenItem) {
                      return ListTile(
                        title: Text(item.title),
                        enabled: item.isEnabled,
                        onTap: () => {},
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