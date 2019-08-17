
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/data/MainRepositoryImpl.dart';
import 'package:todo_app/domain/MainRepository.dart';
import 'package:todo_app/domain/model/DrawerItemModels.dart';

class MainBloc {
  static const String RECORD_PAGE_ROUTE = 'record_page_route';
  static const String CALENDAR_PAGE_ROUTE = 'calendar_page_route';

  final MainRepository _repository = MainRepositoryImpl();

  final _drawerItems = BehaviorSubject<List<BaseDrawerItemModel>>();
  Observable<List<BaseDrawerItemModel>> get drawerItems => _drawerItems.stream;

  String _currentPageRoute;
  String get currentPageRoute => _currentPageRoute;

  MainBloc() {
    _init();
  }

  _init() async {
    _drawerItems.sink.add(await _repository.getDrawerItems());
    _currentPageRoute = RECORD_PAGE_ROUTE;
  }

  dispose() {
    _drawerItems.close();
  }
}
