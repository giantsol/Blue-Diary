
import 'package:flutter/material.dart';
import 'package:todo_app/domain/model/DrawerItemModels.dart';

import 'MainBloc.dart';

class AppDrawer extends StatelessWidget {

  final MainBloc bloc;

  AppDrawer(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.drawerItems,
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
                    BaseDrawerItemModel model = itemModels[index];
                    if (model is DrawerHeaderModel) {
                      return DrawerHeader(
                        child: Text(model.title),
                      );
                    } else if (model is DrawerItemModel) {
                      return _DrawerItem(
                        child: Text(model.title),
                        selected: model.isSelected,
                        enabled: model.isEnabled,
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