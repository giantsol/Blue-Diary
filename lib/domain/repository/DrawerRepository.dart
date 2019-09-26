
import 'package:todo_app/domain/entity/DrawerItem.dart';

abstract class DrawerRepository {
  DrawerHeaderItem getDrawerHeaderItem();
  List<DrawerChildScreenItem> getDrawerChildScreenItems();
  List<DrawerScreenItem> getDrawerScreenItems();
  void setCurrentDrawerChildScreenItem(String key);
}