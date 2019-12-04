
import 'package:todo_app/presentation/App.dart';

class GetUserPasswordUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<String> invoke() {
    return _prefsRepository.getUserPassword();
  }
}