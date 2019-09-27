
import 'package:rxdart/rxdart.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AppPreferences {
  static const String KEY_USER_PASSWORD = 'user.password';

  final _prefs = BehaviorSubject<StreamingSharedPreferences>();

  AppPreferences() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs.value = await StreamingSharedPreferences.instance;
  }

  Future<String> getUserPassword() async {
    return _prefs.value.getString(KEY_USER_PASSWORD, defaultValue: '').getValue();
  }

  Future<bool> setUserPassword(String password) async {
    return _prefs.value.setString(KEY_USER_PASSWORD, password);
  }
}