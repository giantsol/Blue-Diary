
import 'package:flutter/foundation.dart';
import 'package:preferences/preference_service.dart';

class AppPreferences {
  static const String KEY_USER_PASSWORD = 'user.password';
  // should keep using 'default.lock' key to be compatible with users' previous settings
  static const String KEY_USE_LOCK_SCREEN = 'default.lock';
  static const String KEY_RECOVERY_EMAIL = 'recovery.email';
  static const String KEY_USER_CHECKED_TO_DO_BEFORE = 'user.checked.to.do.before';
  static const String KEY_SHOWN_WEEK_SCREEN_TUTORIAL = 'shown.week.screen.tutorial';
  static const String KEY_SHOWN_DAY_SCREEN_TUTORIAL = 'shown.day.screen.tutorial';
  static const String KEY_REAL_FIRST_LAUNCH_DATE = 'real.first.launch.date';
  static const String KEY_USE_REAL_FIRST_LAUNCH_DATE = 'use.real.first.launch.date';
  static const String KEY_CUSTOM_FIRST_LAUNCH_DATE = 'custom.first.launch.date';

  Future<String> getUserPassword() async {
    return PrefService.getString(KEY_USER_PASSWORD) ?? '';
  }

  Future<void> setUserPassword(String password) {
    return PrefService.setString(KEY_USER_PASSWORD, password);
  }

  Future<bool> getUseLockScreen() async {
    return PrefService.getBool(KEY_USE_LOCK_SCREEN) ?? false;
  }

  Future<void> setUseLockScreen(bool value) {
    return PrefService.setBool(KEY_USE_LOCK_SCREEN, value);
  }

  Future<String> getRecoveryEmail() async {
    return PrefService.getString(KEY_RECOVERY_EMAIL) ?? '';
  }

  Future<bool> getUserCheckedToDoBefore() async {
    return PrefService.getBool(KEY_USER_CHECKED_TO_DO_BEFORE) ?? false;
  }

  void setUserCheckedToDoBefore() {
    PrefService.setBool(KEY_USER_CHECKED_TO_DO_BEFORE, true);
  }

  Future<bool> hasShownWeekScreenTutorial() async {
    return PrefService.getBool(KEY_SHOWN_WEEK_SCREEN_TUTORIAL) ?? false;
  }

  void setShownWeekScreenTutorial() {
    PrefService.setBool(KEY_SHOWN_WEEK_SCREEN_TUTORIAL, true);
  }

  Future<bool> hasShownDayScreenTutorial() async {
    return PrefService.getBool(KEY_SHOWN_DAY_SCREEN_TUTORIAL) ?? false;
  }

  void setShownDayScreenTutorial() {
    PrefService.setBool(KEY_SHOWN_DAY_SCREEN_TUTORIAL, true);
  }

  Future<String> getRealFirstLaunchDateString() async {
    return PrefService.getString(KEY_REAL_FIRST_LAUNCH_DATE) ?? '';
  }

  void setRealFirstLaunchDateString(String value) {
    PrefService.setString(KEY_REAL_FIRST_LAUNCH_DATE, value);
  }

  Future<bool> getUseRealFirstLaunchDate() async {
    return PrefService.getBool(KEY_USE_REAL_FIRST_LAUNCH_DATE) ?? true;
  }

  Future<String> getCustomFirstLaunchDateString() async {
    return PrefService.getString(KEY_CUSTOM_FIRST_LAUNCH_DATE) ?? '';
  }

  void setCustomFirstLaunchDateString(String value) {
    PrefService.setString(KEY_CUSTOM_FIRST_LAUNCH_DATE, value);
  }
}