
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {

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
                  children: <Widget>[
                    DrawerHeader(
                      child: Text('ToDo App'),
                    ),
                    _DrawerItem(
                      child: Text('기록'),
                    ),
                    _DrawerItem(
                      child: Text('달력'),
                    ),
                    _DrawerItem(
                      child: Text('통계'),
                    ),
                    _DrawerItem(
                      child: Text('설정'),
                    ),
                    Spacer(),
                    _DrawerItem(
                      child: Text('About'),
                    ),
                    _DrawerItem(
                      child: Text('버그 리포트'),
                    ),
                  ],
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

  final Widget child;
  final bool enabled;
  final bool selected;

  const _DrawerItem({
    Key key,
    @required this.child,
    this.enabled = true,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: this.child,
      onTap: () {
        Navigator.pop(context);
      },
      enabled: this.enabled,
      selected: this.selected,
    );
  }

}