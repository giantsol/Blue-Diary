
import 'package:todo_app/domain/repository/PrefRepository.dart';

class CreatePasswordUsecases {
  final PrefsRepository _prefsRepository;

  const CreatePasswordUsecases(this._prefsRepository);

  Future<bool> setUserPassword(String password) async {
    return _prefsRepository.setUserPassword(password);
  }
}