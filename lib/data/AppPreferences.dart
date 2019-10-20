
import 'package:preferences/preference_service.dart';

class AppPreferences {
  static const String KEY_USER_PASSWORD = 'user.password';
  static const String KEY_USE_LOCK_SCREEN = 'use.lock.screen';
  static const String KEY_RECOVERY_EMAIL = 'recovery.email';

  AppPreferences() {
    _initPrefs();
  }

  Future<void> _initPrefs() async { }

  Future<String> getUserPassword() async {
    return PrefService.getString(KEY_USER_PASSWORD) ?? '';
  }

  Future<void> setUserPassword(String password) async {
    return PrefService.setString(KEY_USER_PASSWORD, password);
  }

  Future<bool> getUseLockScreen() async {
    return PrefService.getBool(KEY_USE_LOCK_SCREEN) ?? false;
  }

  Future<void> setUseLockScreen(bool value) async {
    return PrefService.setBool(KEY_USE_LOCK_SCREEN, value);
  }

  Future<String> getRecoveryEmail() async {
    return PrefService.getString(KEY_RECOVERY_EMAIL) ?? '';
  }
}