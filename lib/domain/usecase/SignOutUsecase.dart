
import 'package:todo_app/domain/repository/UserRepository.dart';

class SignOutUsecase {
  final UserRepository _userRepository;

  SignOutUsecase(this._userRepository);

  Future<bool> invoke() {
    return _userRepository.signOut();
  }
}