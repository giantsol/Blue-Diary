
import 'package:preferences/preference_service.dart';

class AppPreferences {
  static const String KEY_USER_PASSWORD = 'user.password';
  static const String KEY_DEFAULT_LOCK = 'default.lock';
  static const String KEY_RECOVERY_EMAIL = 'recovery.email';

  AppPreferences() {
    _initPrefs();
  }

  Future<void> _initPrefs() async { }

  Future<String> getUserPassword() async {
    return PrefService.getString(KEY_USER_PASSWORD) ?? '';
  }

  Future<bool> setUserPassword(String password) async {
    return PrefService.setString(KEY_USER_PASSWORD, password);
  }

  Future<bool> getDefaultLocked() async {
    return PrefService.getBool(KEY_DEFAULT_LOCK) ?? false;
  }

  Future<bool> setDefaultLocked(bool value) async {
    return PrefService.setBool(KEY_DEFAULT_LOCK, value);
  }

  Future<String> getRecoveryEmail() async {
    return PrefService.getString(KEY_RECOVERY_EMAIL) ?? '';
  }
}