import 'package:flutter/material.dart';

import 'MainBloc.dart';
import 'MainBlocProvider.dart';
import 'record/RecordPage.dart';
import 'calendar/CalendarPage.dart';
import 'AppDrawer.dart';

class Main extends StatefulWidget {

  @override
  State createState() {
    return _MainState();
  }

}

class _MainState extends State<Main> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  MainBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = MainBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Navigator(
              initialRoute: MainBloc.RECORD_PAGE_ROUTE,
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case MainBloc.RECORD_PAGE_ROUTE:
                    builder = (BuildContext _) => RecordPage();
                    break;
                  case MainBloc.CALENDAR_PAGE_ROUTE:
                    builder = (BuildContext _) => CalendarPage();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
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
        endDrawer: AppDrawer(bloc),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

}
