
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/usecase/InputPasswordUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordState.dart';
import 'package:todo_app/presentation/widgets/VirtualKeyboard.dart';

class InputPasswordBloc {
  final _state = BehaviorSubject<InputPasswordState>.seeded(InputPasswordState());
  InputPasswordState getInitialState() => _state.value;
  Stream<InputPasswordState> observeState() => _state.distinct();

  final InputPasswordUsecases _usecases = dependencies.inputPasswordUsecases;

  InputPasswordBloc() {
    _initState();
  }

  void _initState() { }

  void onCloseClicked(BuildContext context) {
    Navigator.pop(context);
  }

  void onVirtualKeyPressed(BuildContext context, VirtualKeyboardKey key, Function() onSuccess, Function() onFail) {
    if (key.type == VirtualKeyboardKeyType.BACKSPACE) {
      _onBackspacePressed();
    } else {
      _onKeyPressed(context, key.text, onSuccess, onFail);
    }
  }

  void _onBackspacePressed() {
    final currentPassword = _state.value.password;
    if (currentPassword.length != 0) {
      _state.add(_state.value.buildNew(
        password: currentPassword.substring(0, currentPassword.length - 1),
      ));
    }
  }

  Future<void> _onKeyPressed(BuildContext context, String key, Function() onSuccess, Function() onFail) async {
    final updatedPassword = '${_state.value.password}$key';
    if (updatedPassword.length == 4) {
      _state.add(_state.value.buildNew(
        password: updatedPassword,
        isLoading: true,
      ));
      final savedPassword = await _usecases.getUserPassword();
      if (updatedPassword == savedPassword) {
        Navigator.pop(context);
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        final updatedFailCount = _state.value.failCount + 1;
        if (updatedFailCount >= InputPasswordState.MAX_FAIL_COUNT) {
          Navigator.pop(context);
          if (onFail != null) {
            onFail();
          }
        } else {
          _state.add(_state.value.buildNew(
            password: '',
            failCount: updatedFailCount,
            isLoading: false,
          ));
        }
      }
    } else {
      _state.add(_state.value.buildNew(password: updatedPassword));
    }
  }

  void dispose() {
    _state.close();
  }
}
