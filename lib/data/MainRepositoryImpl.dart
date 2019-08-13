
import 'package:todo_app/domain/MainRepository.dart';
import 'package:todo_app/domain/model/DrawerItemModels.dart';

class MainRepositoryImpl implements MainRepository {

  final List<BaseDrawerItemModel> _drawerItems = [
    DrawerHeaderModel('제목'),
    DrawerItemModel('기록', true, true),
    DrawerItemModel('달력', false, true),
    DrawerItemModel('통계', false, false),
    DrawerItemModel('설정', false, false),
    DrawerSpacerModel(),
    DrawerItemModel('About', false, false),
    DrawerItemModel('버그리포트', false, false),
  ];

  @override
  Future<List<BaseDrawerItemModel>> getDrawerItems() {
    return Future.value(_drawerItems);
  }

}