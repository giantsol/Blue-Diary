
import 'package:todo_app/presentation/App.dart';

class SignOutUsecase {
  final _userRepository = dependencies.userRepository;

  Future<bool> invoke() {
    return _userRepository.signOut();
  }
}