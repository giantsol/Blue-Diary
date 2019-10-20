
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/usecase/LockUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/lock/LockScreen.dart';
import 'package:todo_app/presentation/lock/LockState.dart';

class LockBloc {
  final _state = BehaviorSubject<LockState>.seeded(LockState());
  LockState getInitialState() => _state.value;
  Stream<LockState> observeState() => _state.distinct();

  final LockUsecases _usecases = dependencies.lockUsecases;

  LockBloc() {
    _initState();
  }

  void _initState() { }

  Future<void> onVirtualKeyPressed(BuildContext context, VirtualKeyboardKey key) async {
    if (key.type == VirtualKeyboardKeyType.BACKSPACE) {
      final currentPassword = _state.value.password;
      if (currentPassword.length != 0) {
        _state.add(_state.value.buildNew(
          password: currentPassword.substring(0, currentPassword.length - 1),
        ));
      }
    } else {
      final updatedPassword = '${_state.value.password}${key.text}';
      if (updatedPassword.length == 4) {
        final savedPassword = await _usecases.getUserPassword();
        if (updatedPassword == savedPassword) {
          Navigator.pop(context);
        } else {
          final updatedFailCount = _state.value.failCount + 1;
          if (updatedFailCount >= LockState.MAX_FAIL_COUNT) {
            SystemNavigator.pop();
          } else {
            _state.add(_state.value.buildNew(
              password: '',
              failCount: updatedFailCount,
            ));
          }
        }
      } else {
        _state.add(_state.value.buildNew(password: updatedPassword));
      }
    }
  }

  void dispose() {

  }
}
