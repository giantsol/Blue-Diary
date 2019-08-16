import 'package:flutter/material.dart';
import 'package:todo_app/presentation/AppDrawer.dart';

import 'MainBloc.dart';
import 'MainBlocProvider.dart';

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
