
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SetUserPasswordUsecase {
  final PrefsRepository _prefsRepository;

  SetUserPasswordUsecase(this._prefsRepository);

  Future<void> invoke(String password) {
    return _prefsRepository.setUserPassword(password);
  }
}