
import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:preferences/preferences.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/presentation/settings/SettingsBloc.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsBlocDelegator settingsBlocDelegator;

  SettingsScreen({
    @required this.settingsBlocDelegator,
  });

  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SettingsBloc(delegator: widget.settingsBlocDelegator);
    _bloc.setNeedUpdateListener(_needUpdateListener);
  }

  void _needUpdateListener() {
    setState(() { });
  }

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.delegator = widget.settingsBlocDelegator;
  }

  @override
  Widget build(BuildContext context) {
    return PreferencePage([
      PreferenceTitle(AppLocalizations.of(context).settingsGeneral),
      SwitchPreference(
        AppLocalizations.of(context).settingsUseLockScreen,
        AppPreferences.KEY_USE_LOCK_SCREEN,
        defaultVal: false,
        onChange: () => _bloc.onUseLockScreenChanged(context),
      ),
      PreferenceTitle(AppLocalizations.of(context).settingsResetPassword),
      TextFieldPreference(
        AppLocalizations.of(context).settingsRecoveryEmail,
        AppPreferences.KEY_RECOVERY_EMAIL,
        keyboardType: TextInputType.emailAddress,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: FlatButton(
          child: Text(AppLocalizations.of(context).sendTempPassword),
          onPressed: () => _bloc.onSendTempPasswordClicked(context),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: FlatButton(
          child: Text(AppLocalizations.of(context).settingsResetPassword),
          onPressed: () => _bloc.onResetPasswordClicked(context),
        ),
      )
    ]);
  }
}