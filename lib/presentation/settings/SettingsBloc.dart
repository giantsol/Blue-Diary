
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/usecase/GetCustomFirstLaunchDateStringUsecase.dart';
import 'package:todo_app/domain/usecase/GetRealFirstLaunchDateStringUsecase.dart';
import 'package:todo_app/domain/usecase/GetUseLockScreenUsecase.dart';
import 'package:todo_app/domain/usecase/GetUserPasswordUsecase.dart';
import 'package:todo_app/domain/usecase/SetCustomFirstLaunchDateUsecase.dart';
import 'package:todo_app/domain/usecase/SetUseLockScreenUsecase.dart';
import 'package:todo_app/domain/usecase/SetUserPasswordUsecase.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordScreen.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordScreen.dart';

class SettingsBloc {
  void Function() _needUpdateListener;

  final _twoSeconds = const Duration(seconds: 2);

  SettingsBlocDelegator delegator;

  final _setUserPasswordUsecase = SetUserPasswordUsecase();
  final _getUserPasswordUsecase = GetUserPasswordUsecase();
  final _getUseLockScreenUsecase = GetUseLockScreenUsecase();
  final _setUseLockScreenUsecase = SetUseLockScreenUsecase();
  final _getRealFirstLaunchDateStringUsecase = GetRealFirstLaunchDateStringUsecase();
  final _setCustomFirstLaunchDateUsecase = SetCustomFirstLaunchDateUsecase();
  final _getCustomFirstLaunchDateStringUsecase = GetCustomFirstLaunchDateStringUsecase();

  SettingsBloc({
    @required this.delegator,
  });

  void updateDelegator(SettingsBlocDelegator delegator) {
    this.delegator = delegator;
  }

  void setNeedUpdateListener(void Function() listener) {
    this._needUpdateListener = listener;
  }

  Future<void> onUseLockScreenChanged(BuildContext context) async {
    final useLockScreen = await _getUseLockScreenUsecase.invoke();
    final userPassword = await _getUserPasswordUsecase.invoke();

    if (useLockScreen && userPassword.isEmpty) {
      _setUseLockScreenUsecase.invoke(false);
      _showCreatePasswordDialog(context,
        onPasswordCreated: () {
          _setUseLockScreenUsecase.invoke(true);
          if (_needUpdateListener != null) {
            _needUpdateListener();
          }
        }
      );
    } else if (!useLockScreen && userPassword.isNotEmpty) {
      // set it to true forcefully instantly.
      // will set to false when user inputs password correctly
      _setUseLockScreenUsecase.invoke(true);

      delegator.showBottomSheet((context) =>
        InputPasswordScreen(onSuccess: () {
          _setUseLockScreenUsecase.invoke(false);
          if (_needUpdateListener != null) {
            _needUpdateListener();
          }
        }, onFail: () {
          delegator.showSnackBar(AppLocalizations.of(context).unlockFail, _twoSeconds);
        }),
      );
    }
  }

  Future<void> _showCreatePasswordDialog(BuildContext context, {
    void Function() onPasswordCreated,
  }) async {
    return Utils.showAppDialog(context,
      AppLocalizations.of(context).createPassword,
      AppLocalizations.of(context).createPasswordBody,
      null,
        () => _onCreatePasswordOkClicked(context, onPasswordCreated: onPasswordCreated),
    );
  }

  Future<void> _onCreatePasswordOkClicked(BuildContext context, {
    void Function() onPasswordCreated,
  }) async {
    final successMsg = AppLocalizations.of(context).createPasswordSuccess;
    final failMsg = AppLocalizations.of(context).createPasswordFail;

    delegator.showBottomSheet((context) => CreatePasswordScreen(),
      onClosed: () async {
        final isPasswordSaved = await _getUserPasswordUsecase.invoke().then((s) => s.length > 0);
        if (isPasswordSaved) {
          delegator.showSnackBar(successMsg, _twoSeconds);
          if (onPasswordCreated != null) {
            onPasswordCreated();
          }
        } else {
          delegator.showSnackBar(failMsg, _twoSeconds);
        }
      }
    );
  }

  Future<void> onResetPasswordClicked(BuildContext context) async {
    final prevPassword = await _getUserPasswordUsecase.invoke();

    if (prevPassword.isEmpty) {
      _showCreatePasswordDialog(context);
    } else {
      final changedMsg = AppLocalizations.of(context).passwordChanged;
      final unchangedMsg = AppLocalizations.of(context).passwordUnchanged;

      delegator.showBottomSheet((context) =>
        InputPasswordScreen(
          onSuccess: () async {
            delegator.showBottomSheet((context) => CreatePasswordScreen(),
              onClosed: () async {
                final changedPassword = await _getUserPasswordUsecase.invoke();
                if (prevPassword != changedPassword) {
                  delegator.showSnackBar(changedMsg, _twoSeconds);
                } else {
                  delegator.showSnackBar(unchangedMsg, _twoSeconds);
                }
              }
            );
          }
        )
      );
    }
  }

  void onFeedbackClicked(context) {
    Utils.showAppDialog(context,
      AppLocalizations.of(context).leaveFeedbackTitle,
      AppLocalizations.of(context).leaveFeedbackBody,
      null,
        () => OpenAppstore.launch(androidAppId: 'com.giantsol.blue_diary'),
    );
  }

  Future<void> onUseRealFirstLaunchDateChanged() async {
    final firstLaunchDateString = await _getRealFirstLaunchDateStringUsecase.invoke();
    final firstLaunchDate = firstLaunchDateString.isEmpty ? DateTime.now() : DateTime.parse(firstLaunchDateString);
    _setCustomFirstLaunchDateUsecase.invoke(firstLaunchDate);

    if (_needUpdateListener != null) {
      _needUpdateListener();
    }
  }

  Future<void> onCustomFirstLaunchDateClicked(BuildContext context) async {
    final customFirstLaunchDateString = await _getCustomFirstLaunchDateStringUsecase.invoke();
    DatePicker.showDatePicker(
      context,
      onConfirm: (date) => _setCustomFirstLaunchDateUsecase.invoke(date),
      currentTime: DateTime.parse(customFirstLaunchDateString),
      locale: Localizations.localeOf(context).languageCode == 'ko' ? LocaleType.ko : LocaleType.en,
    );
  }
}
