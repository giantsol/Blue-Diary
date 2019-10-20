
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SettingsUsecases {
  final PrefsRepository _prefsRepository;

  const SettingsUsecases(this._prefsRepository);

  Future<bool> getUseLockScreen() async {
    return _prefsRepository.getUseLockScreen();
  }

  void setUseLockScreen(bool value) {
    _prefsRepository.setUseLockScreen(value);
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