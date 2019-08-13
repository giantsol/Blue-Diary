
abstract class BaseDrawerItemModel { }

class DrawerItemModel implements BaseDrawerItemModel {

  final String title;
  final bool isSelected;
  final bool isEnabled;

  DrawerItemModel(this.title, this.isSelected, this.isEnabled);

}

class DrawerHeaderModel implements BaseDrawerItemModel {

  final String title;

  DrawerHeaderModel(this.title);

}

class DrawerSpacerModel implements BaseDrawerItemModel {

  DrawerSpacerModel();

}
