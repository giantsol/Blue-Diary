
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/usecase/SetUserPasswordUsecase.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordState.dart';
import 'package:todo_app/presentation/widgets/VirtualKeyboard.dart';

class CreatePasswordBloc {
  final _state = BehaviorSubject<CreatePasswordState>.seeded(CreatePasswordState());
  CreatePasswordState getInitialState() => _state.value;
  Stream<CreatePasswordState> observeState() => _state.distinct();

  final SetUserPasswordUsecase _setUserPasswordUsecase;

  CreatePasswordBloc(PrefsRepository prefsRepository)
    : _setUserPasswordUsecase = SetUserPasswordUsecase(prefsRepository);

  void onCloseClicked(BuildContext context) {
    Navigator.pop(context);
  }

  void onVirtualKeyPressed(BuildContext context, VirtualKeyboardKey key) {
    if (key.type == VirtualKeyboardKeyType.BACKSPACE) {
      _onBackspacePressed();
    } else {
      _onKeyPressed(context, key.text);
    }
  }

  void _onBackspacePressed() {
    if (_state.value.phase == CreatePasswordPhase.FIRST) {
      final currentPassword = _state.value.password;
      if (currentPassword.length != 0) {
        _state.add(_state.value.buildNew(
          password: currentPassword.substring(0, currentPassword.length - 1),
        ));
      }
    } else {
      final currentPassword = _state.value.passwordConfirm;
      if (currentPassword.length != 0) {
        _state.add(_state.value.buildNew(
          passwordConfirm: currentPassword.substring(0, currentPassword.length - 1),
        ));
      }
    }
  }

  void _onKeyPressed(BuildContext context, String key) {
    if (_state.value.phase == CreatePasswordPhase.FIRST) {
      final updatedPassword = '${_state.value.password}$key';
      if (updatedPassword.length == 4) {
        _state.add(_state.value.buildNew(
          phase: CreatePasswordPhase.SECOND,
          password: updatedPassword,
        ));
      } else {
        _state.add(_state.value.buildNew(password: updatedPassword));
      }
    } else {
      final updatedPassword = '${_state.value.passwordConfirm}$key';
      if (updatedPassword.length == 4) {
        final isConfirmed = updatedPassword == _state.value.password;
        if (isConfirmed) {
          _setUserPasswordUsecase.invoke(updatedPassword);
          Navigator.pop(context);
        } else {
          _state.add(_state.value.buildNew(
            errorMsg: AppLocalizations.of(context).confirmPasswordFail,
            passwordConfirm: '',
          ));
        }
      } else {
        _state.add(_state.value.buildNew(passwordConfirm: updatedPassword));
      }
    }
  }
}