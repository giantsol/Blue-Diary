
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:preferences/preferences.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/data/datasource/AppPreferences.dart';
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
    _bloc.updateDelegator(widget.settingsBlocDelegator);
  }

  @override
  Widget build(BuildContext context) {
    return PreferencePage([
      PreferenceTitle(AppLocalizations.of(context).settingsLock),
      SwitchPreference(
        AppLocalizations.of(context).settingsUseLockScreen,
        AppPreferences.KEY_USE_LOCK_SCREEN,
        defaultVal: false,
        onChange: () => _bloc.onUseLockScreenChanged(context),
      ),
      FlatButton(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context).settingsResetPassword),
        ),
        onPressed: () => _bloc.onResetPasswordClicked(context),
      ),
      PreferenceTitle(AppLocalizations.of(context).settingsEtc),
      FlatButton(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context).settingsFeedback),
        ),
        onPressed: () => _bloc.onFeedbackClicked(context),
      ),
      !kReleaseMode ? _DeveloperSettings(bloc: _bloc) : const SizedBox.shrink(),
    ]);
  }
}

class _DeveloperSettings extends StatelessWidget {
  final SettingsBloc bloc;

  _DeveloperSettings({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PreferenceTitle(AppLocalizations.of(context).settingsDeveloper),
        SwitchPreference(
          AppLocalizations.of(context).settingsUseRealFirstLaunchDate,
          AppPreferences.KEY_USE_REAL_FIRST_LAUNCH_DATE,
          defaultVal: true,
          onChange: () => bloc.onUseRealFirstLaunchDateChanged(),
        ),
        PreferenceHider([
          FlatButton(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(AppLocalizations.of(context).settingsCustomFirstLaunchDate),
            ),
            onPressed: () => bloc.onCustomFirstLaunchDateClicked(context),
          ),
        ], AppPreferences.KEY_USE_REAL_FIRST_LAUNCH_DATE),
      ],
    );
  }
}