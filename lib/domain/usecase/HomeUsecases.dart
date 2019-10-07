
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/domain/repository/DrawerRepository.dart';

class HomeUsecases {
  final DrawerRepository _drawerRepository;

  const HomeUsecases(this._drawerRepository);

  List<DrawerItem> getAllDrawerItems() {
    final headerItem = _drawerRepository.getDrawerHeaderItem();
    final childScreenItems = _drawerRepository.getDrawerChildScreenItems();
    final screenItems = _drawerRepository.getDrawerScreenItems();

    final List<DrawerItem> allDrawerItems = [childScreenItems, screenItems].expand((l) => l).toList();
    // 4번째 아이템 뒤에 공백을 넣음
    if (allDrawerItems.length >= 2) {
      allDrawerItems.insert(2, DrawerSpacerItem());
    }
    allDrawerItems.insert(0, headerItem);
    return allDrawerItems;
  }

  void setCurrentDrawerChildScreenItem(String key) {
    _drawerRepository.setCurrentDrawerChildScreenItem(key);
  }
}