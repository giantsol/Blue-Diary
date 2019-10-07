
import 'package:todo_app/domain/repository/PrefRepository.dart';

class CreatePasswordUsecases {
  final PrefsRepository _prefsRepository;

  const CreatePasswordUsecases(this._prefsRepository);

  void setUserPassword(String password) {
    _prefsRepository.setUserPassword(password);
  }
}