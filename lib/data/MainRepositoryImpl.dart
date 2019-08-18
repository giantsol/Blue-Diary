
import 'package:todo_app/domain/DrawerItemModels.dart';
import 'package:todo_app/domain/MainRepository.dart';
import 'package:todo_app/domain/PageModel.dart';

class MainRepositoryImpl implements MainRepository {

  // todo: const로 다 때려박아도 _pages[0] = PageModel(...) 식으로 되는디.. 이건 어케막징
  final List<PageModel> _pages = const [
    const PageModel('기록', PageModel.ROUTE_RECORD, true),
    const PageModel('달력', PageModel.ROUTE_CALENDAR, true),
    const PageModel('통계', PageModel.ROUTE_STATISTICS, false),
    const PageModel('설정', PageModel.ROUTE_SETTINGS, false),
    const PageModel('About', PageModel.ROUTE_ABOUT, false),
    const PageModel('버그리포트', PageModel.ROUTE_REPORT_BUG, false),
  ];

  final DrawerHeaderModel _drawerHeader = DrawerHeaderModel('제목');
  final DrawerSpacerModel _drawerSpacer = DrawerSpacerModel();

  int _currentPageIndex = 0;

  @override
  List<BaseDrawerItemModel> getDrawerItems() {
    final drawerItems = List<BaseDrawerItemModel>();
    for (int i = 0; i < _pages.length; i++) {
      drawerItems.add(DrawerItemModel.fromPageModel(_pages[i], i == _currentPageIndex));
    }
    drawerItems.insert(4, _drawerSpacer);
    drawerItems.insert(0, _drawerHeader);

    return drawerItems;
  }

  @override
  PageModel getCurrentPage() {
    return _pages[_currentPageIndex];
  }

  @override
  setCurrentPage(PageModel pageModel) {
    _currentPageIndex = _pages.indexOf(pageModel);
  }

}