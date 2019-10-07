
import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:preferences/preferences.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/presentation/settings/SettingsBloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final _EMAIL_VALIDATION_REGEX = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SettingsBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: PreferencePage([
        PreferenceTitle(AppLocalizations.of(context).settingsGeneral),
        SwitchPreference(
          AppLocalizations.of(context).settingsDefaultLock,
          AppPreferences.KEY_DEFAULT_LOCK,
          defaultVal: false,
          onChange: () => _bloc.onDefaultLockChanged(context, _scaffoldKey.currentState),
        ),
        // todo: 메일 지원하면 풀어야함
//        PreferenceTitle(AppLocalizations.of(context).settingsResetPassword),
//        TextFieldPreference(
//          AppLocalizations.of(context).settingsRecoveryEmail,
//          AppPreferences.KEY_RECOVERY_EMAIL,
//          keyboardType: TextInputType.emailAddress,
//          validator: (s) {
//            if (!_isEmail(s)) {
//              return AppLocalizations.of(context).invalidEmail;
//            }
//            return null;
//          },
//        ),
//        Align(
//          alignment: Alignment.centerLeft,
//          child: FlatButton(
//            child: Text(AppLocalizations.of(context).sendTempPassword),
//            // email 설정 안했으면 이메일 설정부터 해달라는 Snackbar
//            // 전송되었으면 전송되었다는 snackbar
//            onPressed: () => _bloc.onSendTempPasswordClicked(context, _scaffoldKey.currentState),
//          ),
//        ),
//        Align(
//          alignment: Alignment.centerLeft,
//          child: FlatButton(
//            child: Text(AppLocalizations.of(context).settingsResetPassword),
//            // 아직 설정된 비밀번호가 없으면 처음처럼 비밀번호 설정 다이얼로그
//            onPressed: () => _bloc.onResetPasswordClicked(),
//          ),
//        )
      ]),
    );
  }

  bool _isEmail(String s) {
    return _EMAIL_VALIDATION_REGEX.hasMatch(s);
  }
}