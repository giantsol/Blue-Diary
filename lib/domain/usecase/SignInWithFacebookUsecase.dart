
import 'package:todo_app/domain/repository/UserRepository.dart';

class SignInWithFacebookUsecase {
  final UserRepository _userRepository;

  SignInWithFacebookUsecase(this._userRepository);

  Future<bool> invoke() {
    return _userRepository.signInWithFacebook();
  }
}