
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/HomeRepository.dart';
import 'package:todo_app/domain/home/entity/DrawerItem.dart';

const List<DrawerChildScreenItem> _defaultDrawerChildScreenItems = [
  DrawerChildScreenItem(DrawerChildScreenItem.KEY_RECORD, '기록'),
  DrawerChildScreenItem(DrawerChildScreenItem.KEY_CALENDAR, '달력'),
  DrawerChildScreenItem(DrawerChildScreenItem.KEY_STATISTICS, '통계'),
];

const List<DrawerScreenItem> _defaultDrawerScreenItems = [
  DrawerScreenItem(DrawerScreenItem.KEY_SETTINGS, '설정'),
  DrawerScreenItem(DrawerScreenItem.KEY_ABOUT, 'About'),
  DrawerScreenItem(DrawerScreenItem.KEY_REPORT_BUG, '버그리포트'),
];

class HomeRepositoryImpl implements HomeRepository {
  final _drawerHeaderItem = BehaviorSubject<DrawerHeaderItem>.seeded(DrawerHeaderItem('Todo App'));
  @override
  Stream<DrawerHeaderItem> get drawerHeaderItem => _drawerHeaderItem;

  final _drawerChildScreenItems = BehaviorSubject<List<DrawerChildScreenItem>>.seeded(_defaultDrawerChildScreenItems);
  @override
  Stream<List<DrawerChildScreenItem>> get drawerChildScreenItems => _drawerChildScreenItems;

  final _drawerScreenItems = BehaviorSubject<List<DrawerScreenItem>>.seeded(_defaultDrawerScreenItems);
  @override
  Stream<List<DrawerScreenItem>> get drawerScreenItems => _drawerScreenItems;

  HomeRepositoryImpl() {
    // 시작 시에는 첫번째 아이템이 선택된 상태
    _drawerChildScreenItems.add(_createDrawerChildScreenItemsWithSelected(0));
  }

  List<DrawerChildScreenItem> _createDrawerChildScreenItemsWithSelected(int index) {
    final List<DrawerChildScreenItem> result = List();
    for (int i = 0; i < _defaultDrawerChildScreenItems.length; i++) {
      result.add(_defaultDrawerChildScreenItems[i].getModified(isSelected: i == index));
    }
    return result;
  }

  @override
  selectDrawerChildScreenItem(String key) {
    int index = _defaultDrawerChildScreenItems.indexWhere((i) => i.key == key);
    if (index >= 0) {
      _drawerChildScreenItems.add(_createDrawerChildScreenItemsWithSelected(index));
    }
  }

}