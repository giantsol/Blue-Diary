
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/usecase/GetUseLockScreenUsecase.dart';
import 'package:todo_app/domain/usecase/HomeChildScreenUsecases.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/lock/LockScreen.dart';
import 'package:todo_app/presentation/widgets/SlideUpPageRoute.dart';

class HomeBloc {
  final _state = BehaviorSubject<HomeState>.seeded(HomeState());
  HomeState getInitialState() => _state.value;
  Stream<HomeState> observeState() => _state.distinct();

  final GetUseLockScreenUsecase _getUseLockScreenUsecase;
  final HomeChildScreenUsecases _homeChildScreenUsecases = HomeChildScreenUsecases();

  final List<void Function(String key)> _bottomNavigationItemClickedListeners = [];

  HomeBloc(BuildContext context, PrefsRepository prefsRepository)
    : _getUseLockScreenUsecase = GetUseLockScreenUsecase(prefsRepository)
  {
    _initState(context);
  }

  Future<void> _initState(BuildContext context) async {
    final useLockScreen = await _getUseLockScreenUsecase.invoke();
    final navigationItems = _homeChildScreenUsecases.getNavigationItems();
    final currentChildScreenKey = _homeChildScreenUsecases.getCurrentChildScreenKey();

    if (useLockScreen) {
      await Navigator.push(
        context,
        SlideUpPageRoute(
          page: LockScreen(),
          duration: const Duration(milliseconds: 500),
        ),
      );
      _state.add(_state.value.buildNew(
        childScreenItems: navigationItems,
        currentChildScreenKey: currentChildScreenKey,
      ));
    } else {
      _state.add(_state.value.buildNew(
        childScreenItems: navigationItems,
        currentChildScreenKey: currentChildScreenKey,
      ));
    }
  }

  void onBottomNavigationItemClicked(String key) {
    _homeChildScreenUsecases.setCurrentChildScreenKey(key);

    final navigationItems = _homeChildScreenUsecases.getNavigationItems();
    final currentChildScreenKey = _homeChildScreenUsecases.getCurrentChildScreenKey();
    _state.add(_state.value.buildNew(
      childScreenItems: navigationItems,
      currentChildScreenKey: currentChildScreenKey,
    ));

    for (var listener in _bottomNavigationItemClickedListeners) {
      listener(key);
    }
  }

  void addBottomNavigationItemClickedListener(void Function(String key) listener) {
    if (!_bottomNavigationItemClickedListeners.contains(listener)) {
      _bottomNavigationItemClickedListeners.add(listener);
    }
  }

  void removeBottomNavigationItemClickedListener(void Function(String key) listener) {
    _bottomNavigationItemClickedListeners.remove(listener);
  }

  void dispose() {
    _bottomNavigationItemClickedListeners.clear();
  }
}