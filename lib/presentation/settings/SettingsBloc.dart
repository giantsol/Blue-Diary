
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_appstore/open_appstore.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Secrets.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/usecase/GetCustomFirstLaunchDateStringUsecase.dart';
import 'package:todo_app/domain/usecase/GetRealFirstLaunchDateStringUsecase.dart';
import 'package:todo_app/domain/usecase/GetRecoveryEmailUseCase.dart';
import 'package:todo_app/domain/usecase/GetUseLockScreenUsecase.dart';
import 'package:todo_app/domain/usecase/GetUserPasswordUsecase.dart';
import 'package:todo_app/domain/usecase/SetCustomFirstLaunchDateUsecase.dart';
import 'package:todo_app/domain/usecase/SetUseLockScreenUsecase.dart';
import 'package:todo_app/domain/usecase/SetUserPasswordUsecase.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordScreen.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordScreen.dart';

class SettingsBloc {
  static const _SENDGRID_SEND_API_ENDPOINT = 'https://api.sendgrid.com/v3/mail/send';
  // ignore: non_constant_identifier_names
  static final _EMAIL_VALIDATION_REGEX = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  void Function() _needUpdateListener;

  final _twoSeconds = const Duration(seconds: 2);

  SettingsBlocDelegator delegator;

  final _setUserPasswordUsecase = SetUserPasswordUsecase();
  final _getUserPasswordUsecase = GetUserPasswordUsecase();
  final _getUseLockScreenUsecase = GetUseLockScreenUsecase();
  final _setUseLockScreenUsecase = SetUseLockScreenUsecase();
  final _getRecoveryEmailUseCase = GetRecoveryEmailUseCase();
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
    } else if (!useLockScreen) {
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

  Future<void> onSendTempPasswordClicked(BuildContext context) async {
    final recoveryEmail = await _getRecoveryEmailUseCase.invoke();
    if (!_EMAIL_VALIDATION_REGEX.hasMatch(recoveryEmail)) {
      final message = AppLocalizations.of(context).invalidRecoveryEmail;
      delegator.showSnackBar(message, _twoSeconds);
    } else {
      Utils.showAppDialog(context,
        AppLocalizations.of(context).confirmSendTempPassword,
        AppLocalizations.of(context).confirmSendTempPasswordBody,
        null,
          () => _onConfirmSendTempPasswordOkClicked(context),
      );
    }
  }

  Future<void> _onConfirmSendTempPasswordOkClicked(BuildContext context) async {
    final mailSentMsg = AppLocalizations.of(context).tempPasswordMailSent;
    final mailSendFailedMsg = AppLocalizations.of(context).tempPasswordMailSendFailed;
    final failedToSaveTempPasswordMsg = AppLocalizations.of(context).failedToSaveTempPasswordByUnknownError;

    final prevPassword = await _getUserPasswordUsecase.invoke();
    await _setUserPasswordUsecase.invoke(_createRandomPassword());
    final changedPassword = await _getUserPasswordUsecase.invoke();

    if (changedPassword.isNotEmpty && prevPassword != changedPassword) {
      final recoveryEmail = await _getRecoveryEmailUseCase.invoke();

      final mailTitle = AppLocalizations.of(context).tempPasswordMailSubject;
      final mailBody = AppLocalizations.of(context).tempPasswordMailBody;
      final body = _createEmailBodyJson(
        targetEmail: recoveryEmail,
        title: mailTitle,
        body: '$mailBody$changedPassword');

      final response = await http.post(
        _SENDGRID_SEND_API_ENDPOINT,
        headers: {
          HttpHeaders.authorizationHeader: SENDGRID_AUTHORIZATION,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body,
      );

      if (response.statusCode.toString().startsWith('2')) {
        delegator.showSnackBar(mailSentMsg, _twoSeconds);
      } else {
        delegator.showSnackBar(mailSendFailedMsg, _twoSeconds);
      }
    } else {
      delegator.showSnackBar(failedToSaveTempPasswordMsg, _twoSeconds);
    }
  }

  String _createRandomPassword() {
    final rand = Random();
    return '${rand.nextInt(10)}${rand.nextInt(10)}${rand.nextInt(10)}${rand.nextInt(10)}';
  }

  String _createEmailBodyJson({
    @required String targetEmail,
    @required String title,
    @required String body,
  }) {
    return '{"personalizations":[{"to":[{"email":"$targetEmail"}],"subject":"$title"}],"content": [{"type": "text/plain", "value": "$body"}],"from":{"email":"giantsol64@gmail.com","name":"Blue Diary Developer"}}';
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
