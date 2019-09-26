
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/week/WeekBlocDelegator.dart';

class HomeBloc implements WeekBlocDelegator {
  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  final _usecases = dependencies.homeUsecases;

  HomeBloc() {
    _initState();
  }

  void _initState() {
    final allDrawerItems = _usecases.getAllDrawerItems();
    _state.add(_state.value.buildNew(
      allDrawerItems: allDrawerItems,
    ));
  }

  void onDrawerChildScreenItemClicked(BuildContext context, DrawerChildScreenItem item) {
    Navigator.of(context).pop();
    updateCurrentDrawerChildScreenItem(item.key);
  }

  void onMenuIconClicked(ScaffoldState scaffoldState) {
    scaffoldState?.openEndDrawer();
  }

  @override
  void updateCurrentDrawerChildScreenItem(String key) {
    _usecases.setCurrentDrawerChildScreenItem(key);
    _initState();
  }

  void dispose() {
    _state.close();
  }

}