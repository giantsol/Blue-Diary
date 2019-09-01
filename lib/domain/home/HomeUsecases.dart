
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/entity/DrawerItem.dart';
import 'package:todo_app/domain/home/HomeRepository.dart';
import 'package:tuple/tuple.dart';

class HomeUsecases {
  final HomeRepository _homeRepository;

  const HomeUsecases(this._homeRepository);

  Stream<List<DrawerItem>> get allDrawerItems {
    return Observable.combineLatest3(
      _homeRepository.drawerHeaderItem,
      _homeRepository.drawerChildScreenItems,
      _homeRepository.drawerScreenItems,
      (a, b, c) => Tuple3<DrawerHeaderItem, List<DrawerChildScreenItem>, List<DrawerScreenItem>>(a, b, c),
    ).map((tuple) {
      final headerItem = tuple.item1;
      final childScreenItems = tuple.item2;
      final screenItems = tuple.item3;

      final List<DrawerItem> result = [childScreenItems, screenItems].expand((l) => l).toList();
      // 4번째 아이템 뒤에 공백을 넣음
      if (result.length >= 4) {
        result.insert(4, DrawerSpacerItem());
      }
      result.insert(0, headerItem);
      return result;
    });
  }

  selectDrawerChildScreenItem(DrawerChildScreenItem item) {
    _homeRepository.selectDrawerChildScreenItem(item.key);
  }
}