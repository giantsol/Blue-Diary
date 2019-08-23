
import 'package:todo_app/domain/home/DrawerItem.dart';

class HomeState {
  final List<DrawerItem> allDrawerItems;

  const HomeState({
    this.allDrawerItems = const [],
  });

  String get currentChildScreenKey {
    int index = allDrawerItems.indexWhere((item) => item is DrawerChildScreenItem && item.isSelected);
    if (index >= 0) {
      return (allDrawerItems[index] as DrawerChildScreenItem).key;
    } else {
      return DrawerChildScreenItem.KEY_RECORD;
    }
  }

  HomeState getModified({
    List<DrawerItem> drawerItems,
  }) {
    return HomeState(allDrawerItems: drawerItems ?? this.allDrawerItems);
  }
}

