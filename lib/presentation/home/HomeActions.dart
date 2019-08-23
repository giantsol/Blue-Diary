
import 'package:todo_app/domain/home/DrawerItem.dart';

abstract class HomeAction { }

class SelectDrawerChildScreenItem implements HomeAction {
  final DrawerChildScreenItem selectedItem;

  const SelectDrawerChildScreenItem(this.selectedItem);
}