
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SettingsUsecases {
  final PrefsRepository _prefsRepository;

  const SettingsUsecases(this._prefsRepository);

  Future<bool> getDefaultLocked() async {
    return _prefsRepository.getDefaultLocked();
  }

  Future<bool> setDefaultLocked(bool value) async {
    return _prefsRepository.setDefaultLocked(value);
  }

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }
}