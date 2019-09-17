
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/domain/repository/DrawerRepository.dart';

class DrawerRepositoryImpl implements DrawerRepository {
  final DrawerHeaderItem _drawerHeaderItem = DrawerHeaderItem('ToDo App');
  final List<DrawerChildScreenItem> _drawerChildScreenItems = [
    DrawerChildScreenItem(DrawerChildScreenItem.KEY_RECORD, '기록', isSelected: true),
    DrawerChildScreenItem(DrawerChildScreenItem.KEY_CALENDAR, '달력'),
    DrawerChildScreenItem(DrawerChildScreenItem.KEY_STATISTICS, '통계'),
  ];
  final List<DrawerScreenItem> _drawerScreenItems = [
    DrawerScreenItem(DrawerScreenItem.KEY_SETTINGS, '설정'),
    DrawerScreenItem(DrawerScreenItem.KEY_ABOUT, 'About'),
    DrawerScreenItem(DrawerScreenItem.KEY_REPORT_BUG, '버그리포트'),
  ];

  @override
  List<DrawerChildScreenItem> getDrawerChildScreenItems() => _drawerChildScreenItems;

  @override
  DrawerHeaderItem getDrawerHeaderItem() => _drawerHeaderItem;

  @override
  List<DrawerScreenItem> getDrawerScreenItems() => _drawerScreenItems;

  @override
  setCurrentDrawerChildScreenItem(String key) {
    final index = _drawerChildScreenItems.indexWhere((i) => i.key == key);
    if (index >= 0) {
      for (int i = 0; i < _drawerChildScreenItems.length; i++) {
        _drawerChildScreenItems[i] = _drawerChildScreenItems[i].buildNew(isSelected: i == index);
      }
    }
  }

}