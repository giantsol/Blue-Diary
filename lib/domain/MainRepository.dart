
import 'model/DrawerItemModels.dart';

abstract class MainRepository {

  Future<List<BaseDrawerItemModel>> getDrawerItems();

}
