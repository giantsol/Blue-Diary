
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/DrawerItem.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/settings/SettingsScreen.dart';

class HomeBloc {
  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  final _usecases = dependencies.homeUsecases;

  final List<void Function()> _settingsChangedEventListeners = [];

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
    setCurrentDrawerChildScreenItem(item.key);
  }

  Future<void> onDrawerScreenItemClicked(BuildContext context, DrawerScreenItem item) async {
    if (item.key == DrawerScreenItem.KEY_SETTINGS) {
      Navigator.pop(context);
      await Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        )
      );
      _dispatchSettingsChangedEvent();
    }
  }

  void onMenuIconClicked(ScaffoldState scaffoldState) {
    scaffoldState.openEndDrawer();
  }

  void setCurrentDrawerChildScreenItem(String key) {
    _usecases.setCurrentDrawerChildScreenItem(key);
    _initState();
  }

  Future<void> showBottomSheet(ScaffoldState scaffoldState, Function(BuildContext context) builder, Function(dynamic) onClosed) async {
    final controller = scaffoldState.showBottomSheet(builder);
    if (onClosed != null) {
      onClosed(await controller.closed);
    }
  }

  void showSnackBar(ScaffoldState scaffoldState, Widget widget, Duration duration) {
    scaffoldState.showSnackBar(SnackBar(
      content: widget,
      duration: duration ?? Duration(seconds: 4),
    ));
  }

  void _dispatchSettingsChangedEvent() {
    for (var listener in _settingsChangedEventListeners) {
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