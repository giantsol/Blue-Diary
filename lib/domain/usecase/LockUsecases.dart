
import 'package:todo_app/domain/repository/PrefRepository.dart';

class LockUsecases {
  final PrefsRepository _prefsRepository;

  const LockUsecases(this._prefsRepository);

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }
}