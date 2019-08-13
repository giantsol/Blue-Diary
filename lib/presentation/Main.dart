import 'package:flutter/material.dart';

import 'package:todo_app/presentation/AppDrawer.dart';

class Main extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
        endDrawer: AppDrawer(),
      ),
    );
  }

}

