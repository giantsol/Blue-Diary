
import 'PageModel.dart';

abstract class BaseDrawerItemModel { }

class DrawerItemModel implements BaseDrawerItemModel {
  final PageModel pageModel;
  final bool isSelected;

  // delegate to PageModel
  get title => pageModel.title;
  get isEnabled => pageModel.isEnabled;

  DrawerItemModel(this.pageModel, this.isSelected);

  static DrawerItemModel fromPageModel(PageModel page, bool isSelected) {
    return DrawerItemModel(page, isSelected);
  }
}

class DrawerHeaderModel implements BaseDrawerItemModel {
  final String title;

  DrawerHeaderModel(this.title);
}

class DrawerSpacerModel implements BaseDrawerItemModel {
  DrawerSpacerModel();
}
