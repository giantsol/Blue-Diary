
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/lock/LockScreen.dart';
import 'package:todo_app/presentation/widgets/SlideUpPageRoute.dart';

class HomeBloc {
  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  final _usecases = dependencies.homeUsecases;

  HomeBloc(BuildContext context) {
    _initState(context);
  }

  Future<void> _initState(BuildContext context) async {
    final navigationItems = _usecases.getNavigationItems();
    final currentChildScreenKey = _usecases.getCurrentChildScreenKey();
    _state.add(_state.value.buildNew(
      navigationItems: navigationItems,
      currentChildScreenKey: currentChildScreenKey,
    ));

    final useLockScreen = await _usecases.getUseLockScreen();
    if (useLockScreen) {
      Navigator.push(
        context,
        SlideUpPageRoute(page: LockScreen())
      );
    }
  }

  void onBottomNavigationItemClicked(String key) {
    _usecases.setCurrentChildScreenKey(key);

    final navigationItems = _usecases.getNavigationItems();
    final currentChildScreenKey = _usecases.getCurrentChildScreenKey();
    _state.add(_state.value.buildNew(
      navigationItems: navigationItems,
      currentChildScreenKey: currentChildScreenKey,
    ));
  }
}