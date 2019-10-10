
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Secrets.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/usecase/SettingsUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordScreen.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordScreen.dart';

class SettingsBloc {
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
      _usecases.setDefaultLocked(true); // 비번 입력하기 전에는 바뀌면 안되므로 일단은 다시 되돌려버림
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
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).createPassword,
            style: TextStyle(
              color: AppColors.TEXT_BLACK,
              fontSize: 20,
            ),
          ),
          content: Text(
            AppLocalizations.of(context).createPasswordBody,
            style: TextStyle(
              color: AppColors.TEXT_BLACK_LIGHT,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(
                  color: AppColors.TEXT_BLACK,
                  fontSize: 14,
                ),
              ),
              onPressed: () => _onCreatePasswordCancelClicked(context),
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).ok,
                style: TextStyle(
                  color: AppColors.PRIMARY,
                  fontSize: 14,
                ),
              ),
              onPressed: () => _onCreatePasswordOkClicked(context, scaffoldState),
            )
          ],
        );
      },
    );
  }

  void _onCreatePasswordCancelClicked(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _onCreatePasswordOkClicked(BuildContext context, ScaffoldState scaffoldState) async {
    Navigator.pop(context);
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
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).confirmSendTempPassword,
            style: TextStyle(
              color: AppColors.TEXT_BLACK,
              fontSize: 20,
            ),
          ),
          content: Text(
            AppLocalizations.of(context).confirmSendTempPasswordBody,
            style: TextStyle(
              color: AppColors.TEXT_BLACK_LIGHT,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(
                  color: AppColors.TEXT_BLACK,
                  fontSize: 14,
                ),
              ),
              onPressed: () => _onConfirmSendTempPasswordCancelClicked(context),
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).ok,
                style: TextStyle(
                  color: AppColors.PRIMARY,
                  fontSize: 14,
                ),
              ),
              onPressed: () => _onConfirmSendTempPasswordOkClicked(context, scaffoldState),
            )
          ],
        );
      },
    );
  }

  void _onConfirmSendTempPasswordCancelClicked(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _onConfirmSendTempPasswordOkClicked(BuildContext context, ScaffoldState scaffoldState) async {
    final mailSentMsg = AppLocalizations.of(context).tempPasswordMailSent;
    final mailSendFailedMsg = AppLocalizations.of(context).tempPasswordMailSendFailed;
    final failedToSaveTempPasswordMsg = AppLocalizations.of(context).failedToSaveTempPasswordByUnknownError;
    Navigator.pop(context);
    final prevPassword = await _usecases.getUserPassword();
    await _usecases.setUserPassword(_generateRandomPassword());
    final changedPassword = await _usecases.getUserPassword();
    if (changedPassword.isNotEmpty && prevPassword != changedPassword) {
      final mailTitle = AppLocalizations.of(context).tempPasswordMailSubject;
      final mailBody = AppLocalizations.of(context).tempPasswordMailBody;
      final recoveryEmail = await _usecases.getRecoveryEmail();
      final body = '{"personalizations":[{"to":[{"email":"$recoveryEmail"}],"subject":"$mailTitle"}],"content": [{"type": "text/plain", "value": "$mailBody$changedPassword"}],"from":{"email":"giantsol64@gmail.com","name":"Blue Diary Developer"}}';
      final response = await http.post(
        'https://api.sendgrid.com/v3/mail/send',
        headers: {
          HttpHeaders.authorizationHeader: SENDGRID_AUTHORIZATION,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body,
      );
      if ([200, 201, 202].contains(response.statusCode)) {
        Utils.showSnackBar(scaffoldState, mailSentMsg, _snackBarDuration);
      } else {
        Utils.showSnackBar(scaffoldState, mailSendFailedMsg, _snackBarDuration);
      }
    } else {
      Utils.showSnackBar(scaffoldState, failedToSaveTempPasswordMsg, _snackBarDuration);
    }
  }

  String _generateRandomPassword() {
    final rand = Random();
    return '${rand.nextInt(10)}${rand.nextInt(10)}${rand.nextInt(10)}${rand.nextInt(10)}';
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
