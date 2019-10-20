
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

  final List<void Function()> _settingsChangedEventListeners = [];

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

    final userPassword = await _usecases.getUserPassword();
    if (userPassword.isNotEmpty) {
      Navigator.push(
        context,
        SlideUpPageRoute(page: LockScreen())
      );
    }
  }

  void _dispatchSettingsChangedEvent() {
    for (final listener in _settingsChangedEventListeners) {
      listener();
    }
  }

  void addSettingsChangedListener(void Function() listener) {
    if (!_settingsChangedEventListeners.contains(listener)) {
      _settingsChangedEventListeners.add(listener);
    }
  }

  void removeSettingsChangedListener(void Function() listener) {
    _settingsChangedEventListeners.remove(listener);
  }

  void dispose() {
    _state.close();
    _settingsChangedEventListeners.clear();
  }

}