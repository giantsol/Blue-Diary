
import 'package:todo_app/domain/repository/PrefRepository.dart';

class InputPasswordUsecases {
  final PrefsRepository _prefsRepository;

  const InputPasswordUsecases(this._prefsRepository);

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }
}