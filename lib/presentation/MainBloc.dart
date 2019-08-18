
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/data/MainRepositoryImpl.dart';
import 'package:todo_app/domain/DrawerItemModels.dart';
import 'package:todo_app/domain/MainRepository.dart';
import 'package:todo_app/domain/PageModel.dart';

class MainBloc {
  final MainRepository _repository = MainRepositoryImpl();

  final _drawerItems = BehaviorSubject<List<BaseDrawerItemModel>>();
  Observable<List<BaseDrawerItemModel>> getDrawerItems() => _drawerItems.stream;

  final _currentPage = BehaviorSubject<PageModel>();
  Observable<PageModel> getCurrentPage() => _currentPage.stream;

  MainBloc() {
    _init();
  }

  _init() {
    _drawerItems.sink.add(_repository.getDrawerItems());
    _currentPage.sink.add(_repository.getCurrentPage());
  }


  String getCurrentPageRoute() {
    return _currentPage.value.route;
  }

  onDrawerItemClicked(BuildContext context, DrawerItemModel itemModel) {
    Navigator.pop(context);
    _repository.setCurrentPage(itemModel.pageModel);

    _drawerItems.sink.add(_repository.getDrawerItems());
    _currentPage.sink.add(_repository.getCurrentPage());
  }

  dispose() {
    _drawerItems.close();
    _currentPage.close();
  }
}
