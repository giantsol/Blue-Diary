
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/home/record/RecordBlocDelegator.dart';

class HomeBloc implements RecordBlocDelegator {
  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  final _usecases = dependencies.homeUsecases;

  HomeBloc() {
    _state.add(_state.value.getModified(
      drawerItems: _usecases.getAllDrawerItems(),
    ));
  }

  onDrawerChildScreenItemClicked(BuildContext context, DrawerChildScreenItem item) {
    Navigator.of(context).pop();
    updateCurrentDrawerChildScreenItem(item.key);
  }

  onMenuIconClicked(ScaffoldState scaffoldState) {
    scaffoldState?.openEndDrawer();
  }

  @override
  updateCurrentDrawerChildScreenItem(String key) {
    _usecases.setCurrentDrawerChildScreenItem(key);
    _state.add(_state.value.getModified(drawerItems: _usecases.getAllDrawerItems()));
  }

  dispose() {
    _state.close();
  }

}