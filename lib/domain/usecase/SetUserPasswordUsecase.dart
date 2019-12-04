
import 'package:todo_app/presentation/App.dart';

class SetUserPasswordUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke(String password) {
    return _prefsRepository.setUserPassword(password);
  }
}