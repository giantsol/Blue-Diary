import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/domain/DrawerItemModels.dart';
import 'package:todo_app/domain/PageModel.dart';

import 'MainBloc.dart';
import 'MainBlocProvider.dart';
import 'calendar/CalendarPage.dart';
import 'record/RecordPage.dart';

class Main extends StatefulWidget {
  @override
  State createState() {
    return _MainState();
  }
}

class _MainState extends State<Main> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<NavigatorState> _pageNavigatorKey = GlobalKey();

  MainBloc _bloc;
  StreamSubscription _currentPageSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = MainBlocProvider.of(context);

    // todo: 요 코드 _PageContainer 쪽으로 들어가야 할듯
    _currentPageSubscription = _bloc.getCurrentPage().listen((pageModel) {
      _pageNavigatorKey.currentState.pushReplacementNamed(pageModel.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _PageContainer(
              bloc: _bloc,
              navigatorKey: _pageNavigatorKey,
            ),
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Image.asset('assets/menu.png'),
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              ),
            ),
          ],
        ),
        endDrawer: _AppDrawer(bloc: _bloc),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();

    _currentPageSubscription.cancel();
  }
}

class _PageContainer extends StatelessWidget {
  final MainBloc bloc;
  final GlobalKey navigatorKey;

  _PageContainer({Key key, this.bloc, this.navigatorKey}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: this.navigatorKey,
        initialRoute: this.bloc.getCurrentPageRoute(),
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case PageModel.ROUTE_RECORD:
              builder = (BuildContext _) => RecordPage();
              break;
            case PageModel.ROUTE_CALENDAR:
              builder = (BuildContext _) => CalendarPage();
              break;
            default:
              throw Exception('Not implemented route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      );
  }
}

class _AppDrawer extends StatelessWidget {
  final MainBloc bloc;

  _AppDrawer({Key key, this.bloc}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.getDrawerItems(),
      builder: (context, AsyncSnapshot<List<BaseDrawerItemModel>> snapshot) {
        if (snapshot.hasData) {
          return _buildDrawer(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildDrawer(List<BaseDrawerItemModel> itemModels) {
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
                  children: List.generate(itemModels.length, (index) {
                    BaseDrawerItemModel item = itemModels[index];
                    if (item is DrawerHeaderModel) {
                      return DrawerHeader(
                        child: Text(item.title),
                      );
                    } else if (item is DrawerItemModel) {
                      return _DrawerItem(
                        model: item,
                        onTap: () {
                          bloc.onDrawerItemClicked(context, item);
                        },
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

class _DrawerItem extends StatelessWidget {
  final DrawerItemModel model;
  final Function onTap;

  const _DrawerItem({
    Key key,
    @required this.model,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = this.model;
    return ListTile(
      title: Text(model.title),
      enabled: model.isEnabled,
      selected: model.isSelected,
      onTap: this.onTap,
    );
  }
}
