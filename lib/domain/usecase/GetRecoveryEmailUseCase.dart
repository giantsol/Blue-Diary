
import 'package:todo_app/presentation/App.dart';

class GetRecoveryEmailUseCase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<String> invoke() {
    return _prefsRepository.getRecoveryEmail();
  }
}