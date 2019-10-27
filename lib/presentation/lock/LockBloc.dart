
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/usecase/LockUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/lock/LockState.dart';
import 'package:todo_app/presentation/widgets/VirtualKeyboard.dart';

class LockBloc {
  final _state = BehaviorSubject<LockState>.seeded(LockState());
  LockState getInitialState() => _state.value;
  Stream<LockState> observeState() => _state.distinct();

  final LockUsecases _usecases = dependencies.lockUsecases;

  Future<void> onVirtualKeyPressed(BuildContext context, VirtualKeyboardKey key) async {
    if (key.type == VirtualKeyboardKeyType.BACKSPACE) {
      final currentPassword = _state.value.password;
      if (currentPassword.length != 0) {
        final currentLength = currentPassword.length;

        var animationName;
        if (currentLength == 3) {
          animationName = '3_to_2';
        } else if (currentLength == 2) {
          animationName = '2_to_1';
        } else {
          animationName = '1_to_0';
        }

        _state.add(_state.value.buildNew(
          password: currentPassword.substring(0, currentPassword.length - 1),
          animationName: animationName,
        ));
      }
    } else {
      final updatedPassword = '${_state.value.password}${key.text}';
      final updatedLength = updatedPassword.length;

      var animationName;
      if (updatedLength == 1) {
        animationName = '0_to_1';
      } else if (updatedLength == 2) {
        animationName = '1_to_2';
      } else if (updatedLength == 3) {
        animationName = '2_to_3';
      } else {
        animationName = '3_to_4';
      }
      
      _state.add(_state.value.buildNew(
        animationName: animationName,
        password: updatedPassword,
      ));

      if (updatedLength == 4) {
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
              animationName: '4_to_0',
            ));
          }
        }
      }
    }
  }
}
