
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Secrets.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/usecase/SettingsUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordScreen.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordScreen.dart';

class SettingsBloc {
  static const _SENDGRID_SEND_API_ENDPOINT = 'https://api.sendgrid.com/v3/mail/send';
  final SettingsUsecases _usecases = dependencies.settingsUsecases;

  void Function() _needUpdateListener;

  final _snackBarDuration = const Duration(seconds: 2);

  void setNeedUpdateListener(void Function() listener) {
    this._needUpdateListener = listener;
  }

  Future<void> onDefaultLockChanged(BuildContext context, ScaffoldState scaffoldState) async {
    final isDefaultLocked = await _usecases.getDefaultLocked();
    final userPassword = await _usecases.getUserPassword();

    if (isDefaultLocked && userPassword.isEmpty) {
      _usecases.setDefaultLocked(false);
      _showCreatePasswordDialog(context, scaffoldState);
    } else if (!isDefaultLocked) {
      // set it to true forcefully instantly.
      // will set to false when user inputs password correctly
      _usecases.setDefaultLocked(true);
      Utils.showBottomSheet(scaffoldState, (context) =>
        InputPasswordScreen(onSuccess: () {
          _usecases.setDefaultLocked(false);
          if (_needUpdateListener != null) {
            _needUpdateListener();
          }
        }, onFail: () {
          Utils.showSnackBar(scaffoldState, AppLocalizations.of(context).unlockFail, Duration(seconds: 2));
        }),
      );
    }
  }

  Future<void> _showCreatePasswordDialog(BuildContext context, ScaffoldState scaffoldState) async {
    return Utils.showAppDialog(context,
      AppLocalizations.of(context).createPassword,
      AppLocalizations.of(context).createPasswordBody,
      null,
        () => _onCreatePasswordOkClicked(context, scaffoldState),
    );
  }

  Future<void> _onCreatePasswordOkClicked(BuildContext context, ScaffoldState scaffoldState) async {
    final successMsg = AppLocalizations.of(context).createPasswordSuccess;
    final failMsg = AppLocalizations.of(context).createPasswordFail;
    Utils.showBottomSheet(scaffoldState, (context) => CreatePasswordScreen(),
      onClosed: () async {
        final isPasswordSaved = await _usecases.getUserPassword().then((s) => s.length > 0);
        if (isPasswordSaved) {
          Utils.showSnackBar(scaffoldState, successMsg, _snackBarDuration);
        } else {
          Utils.showSnackBar(scaffoldState, failMsg, _snackBarDuration);
        }
      }
    );
  }

  Future<void> onSendTempPasswordClicked(BuildContext context, ScaffoldState scaffoldState) async {
    final recoveryEmail = await _usecases.getRecoveryEmail();
    if (recoveryEmail.isEmpty) {
      final message = AppLocalizations.of(context).noRecoveryEmail;
      Utils.showSnackBar(scaffoldState, message, _snackBarDuration);
    } else {
      _showConfirmSendTempPasswordDialog(context, scaffoldState);
    }
  }

  Future<void> _showConfirmSendTempPasswordDialog(BuildContext context, ScaffoldState scaffoldState) async {
    return Utils.showAppDialog(context,
      AppLocalizations.of(context).confirmSendTempPassword,
      AppLocalizations.of(context).confirmSendTempPasswordBody,
      null,
        () => _onConfirmSendTempPasswordOkClicked(context, scaffoldState),
    );
  }

  Future<void> _onConfirmSendTempPasswordOkClicked(BuildContext context, ScaffoldState scaffoldState) async {
    final mailSentMsg = AppLocalizations.of(context).tempPasswordMailSent;
    final mailSendFailedMsg = AppLocalizations.of(context).tempPasswordMailSendFailed;
    final failedToSaveTempPasswordMsg = AppLocalizations.of(context).failedToSaveTempPasswordByUnknownError;

    final prevPassword = await _usecases.getUserPassword();
    await _usecases.setUserPassword(_createRandomPassword());
    final changedPassword = await _usecases.getUserPassword();

    if (changedPassword.isNotEmpty && prevPassword != changedPassword) {
      final mailTitle = AppLocalizations.of(context).tempPasswordMailSubject;
      final mailBody = AppLocalizations.of(context).tempPasswordMailBody;
      final recoveryEmail = await _usecases.getRecoveryEmail();
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
        Utils.showSnackBar(scaffoldState, mailSentMsg, _snackBarDuration);
      } else {
        Utils.showSnackBar(scaffoldState, mailSendFailedMsg, _snackBarDuration);
      }
    } else {
      Utils.showSnackBar(scaffoldState, failedToSaveTempPasswordMsg, _snackBarDuration);
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

  Future<void> onResetPasswordClicked(BuildContext context, ScaffoldState scaffoldState) async {
    final prevPassword = await _usecases.getUserPassword();
    if (prevPassword.isEmpty) {
      _showCreatePasswordDialog(context, scaffoldState);
    } else {
      final changedMsg = AppLocalizations.of(context).passwordChanged;
      final unchangedMsg = AppLocalizations.of(context).passwordUnchanged;

      Utils.showBottomSheet(scaffoldState, (context) =>
        InputPasswordScreen(onSuccess: () async {
          Utils.showBottomSheet(scaffoldState, (context) => CreatePasswordScreen(),
            onClosed: () async {
              final changedPassword = await _usecases.getUserPassword();
              if (prevPassword != changedPassword) {
                Utils.showSnackBar(scaffoldState, changedMsg, _snackBarDuration);
              } else {
                Utils.showSnackBar(scaffoldState, unchangedMsg, _snackBarDuration);
              }
            }
          );
        })
      );
    }
  }

  void dispose() {

  }
}
