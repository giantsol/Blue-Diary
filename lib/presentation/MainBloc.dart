
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/data/MainRepositoryImpl.dart';
import 'package:todo_app/domain/MainRepository.dart';
import 'package:todo_app/domain/model/DrawerItemModels.dart';

class MainBloc {
  final MainRepository _repository = MainRepositoryImpl();

  final _drawerItems = BehaviorSubject<List<BaseDrawerItemModel>>();
  Observable<List<BaseDrawerItemModel>> get drawerItems => _drawerItems.stream;

  MainBloc() {
    _init();
  }

  _init() async {
    _drawerItems.sink.add(await _repository.getDrawerItems());
  }

  close() {
    _drawerItems.close();
  }
}

final bloc = MainBloc();