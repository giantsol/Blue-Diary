
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetRecoveryEmailUseCase {
  final PrefsRepository _prefsRepository;

  GetRecoveryEmailUseCase(this._prefsRepository);

  Future<String> invoke() {
    return _prefsRepository.getRecoveryEmail();
  }
}