
import 'package:todo_app/domain/home/DrawerItem.dart';

abstract class HomeRepository {
  Stream<DrawerHeaderItem> get drawerHeaderItem;
  Stream<List<DrawerChildScreenItem>> get drawerChildScreenItems;
  Stream<List<DrawerScreenItem>> get drawerScreenItems;

  void selectDrawerChildScreenItem(String key);
}