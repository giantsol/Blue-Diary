
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';

class PrefsRepositoryImpl implements PrefsRepository {
  final AppPreferences _prefs;

  const PrefsRepositoryImpl(this._prefs);

  @override
  Future<String> getUserPassword() async {
    return _prefs.getUserPassword();
  }

  @override
  Future<bool> setUserPassword(String password) async {
    return _prefs.setUserPassword(password);
  }

  @override
  Future<bool> getDefaultLocked() async {
    return _prefs.getDefaultLocked();
  }

  @override
  Future<bool> setDefaultLocked(bool value) async {
    return _prefs.setDefaultLocked(value);
  }

  @override
  Future<String> getRecoveryEmail() async {
    return _prefs.getRecoveryEmail();
  }
}