
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetUserPasswordUsecase {
  final PrefsRepository _prefsRepository;

  GetUserPasswordUsecase(this._prefsRepository);

  Future<String> invoke() {
    return _prefsRepository.getUserPassword();
  }
}