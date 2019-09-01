
import 'package:todo_app/domain/home/entity/DrawerItem.dart';

abstract class HomeRepository {
  Stream<DrawerHeaderItem> get drawerHeaderItem;
  Stream<List<DrawerChildScreenItem>> get drawerChildScreenItems;
  Stream<List<DrawerScreenItem>> get drawerScreenItems;

  selectDrawerChildScreenItem(String key);
}