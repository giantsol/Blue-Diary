
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SettingsUsecases {
  final PrefsRepository _prefsRepository;

  const SettingsUsecases(this._prefsRepository);

  Future<bool> getDefaultLocked() async {
    return _prefsRepository.getDefaultLocked();
  }

  void setDefaultLocked(bool value) {
    _prefsRepository.setDefaultLocked(value);
  }

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }

  Future<void> setUserPassword(String value) async {
    return _prefsRepository.setUserPassword(value);
  }

  Future<String> getRecoveryEmail() async {
    return _prefsRepository.getRecoveryEmail();
  }
}