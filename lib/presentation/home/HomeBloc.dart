
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/DrawerItem.dart';
import 'package:todo_app/domain/home/HomeUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/HomeActions.dart';
import 'package:todo_app/presentation/home/HomeState.dart';

class HomeBloc {
  final _actions = StreamController<HomeAction>();
  Sink get actions => _actions;

  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState get initialState => _state.value;
  Stream<HomeState> get state => _state.stream.distinct();

  final HomeUsecases _usecases = dependencies.homeUsecases;

  StreamSubscription<List<DrawerItem>> _drawerItemsSubscription;

  HomeBloc() {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case SelectDrawerChildScreenItem:
          _selectDrawerChildScreenItem(action);
          break;
        default:
          throw Exception('HomeBloc action not implemented: $action');
      }
    });

    // 레포지토리의 drawerItems가 바뀔 때 마다 state도 자동 업데이트
    _drawerItemsSubscription = _usecases.allDrawerItems.listen((items) {
      _state.add(_state.value.getModified(drawerItems: items));
    });
  }

  _selectDrawerChildScreenItem(SelectDrawerChildScreenItem action) {
    _usecases.selectDrawerChildScreenItem(action.selectedItem);
  }

  dispose() {
    _actions.close();
    _state.close();

    _drawerItemsSubscription?.cancel();
  }
}