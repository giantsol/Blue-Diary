
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/domain/repository/DrawerRepository.dart';

class DrawerRepositoryImpl implements DrawerRepository {
  final DrawerHeaderItem _drawerHeaderItem = DrawerHeaderItem('ToDo App');
  final List<DrawerChildScreenItem> _drawerChildScreenItems = [
    DrawerChildScreenItem(DrawerChildScreenItem.KEY_RECORD, isSelected: true),
  ];
  final List<DrawerScreenItem> _drawerScreenItems = [
    DrawerScreenItem(DrawerScreenItem.KEY_SETTINGS),
    DrawerScreenItem(DrawerScreenItem.KEY_ABOUT),
  ];

  @override
  List<DrawerChildScreenItem> getDrawerChildScreenItems() => _drawerChildScreenItems;

  @override
  DrawerHeaderItem getDrawerHeaderItem() => _drawerHeaderItem;

  @override
  List<DrawerScreenItem> getDrawerScreenItems() => _drawerScreenItems;

  @override
  void setCurrentDrawerChildScreenItem(String key) {
    final index = _drawerChildScreenItems.indexWhere((i) => i.key == key);
    if (index >= 0) {
      for (int i = 0; i < _drawerChildScreenItems.length; i++) {
        _drawerChildScreenItems[i] = _drawerChildScreenItems[i].buildNew(isSelected: i == index);
      }
    }
  }

}