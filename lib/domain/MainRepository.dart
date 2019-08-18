
import 'DrawerItemModels.dart';
import 'PageModel.dart';

abstract class MainRepository {
  List<BaseDrawerItemModel> getDrawerItems();

  PageModel getCurrentPage();
  setCurrentPage(PageModel pageModel);
}
