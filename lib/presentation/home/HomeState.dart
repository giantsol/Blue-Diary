
import 'package:todo_app/domain/entity/DrawerItem.dart';

class HomeState {
  final List<DrawerItem> allDrawerItems;

  const HomeState({
    this.allDrawerItems = const [],
  });

  HomeState getModified({
    List<DrawerItem> drawerItems,
  }) {
    return HomeState(allDrawerItems: drawerItems ?? this.allDrawerItems);
  }

  String getCurrentChildScreenKey() {
    int index = allDrawerItems.indexWhere((item) => item is DrawerChildScreenItem && item.isSelected);
    if (index >= 0) {
      return (allDrawerItems[index] as DrawerChildScreenItem).key;
    } else {
      return null;
    }
  }

}

