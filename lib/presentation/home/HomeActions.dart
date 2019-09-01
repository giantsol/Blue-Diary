
import 'package:todo_app/domain/home/entity/DrawerItem.dart';

abstract class HomeAction { }

class SelectDrawerChildScreenItem implements HomeAction {
  final DrawerChildScreenItem selectedItem;

  const SelectDrawerChildScreenItem(this.selectedItem);
}