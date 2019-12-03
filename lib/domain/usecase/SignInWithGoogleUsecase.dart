
import 'package:todo_app/domain/repository/UserRepository.dart';

class SignInWithGoogleUsecase {
  final UserRepository _userRepository;

  SignInWithGoogleUsecase(this._userRepository);

  Future<bool> invoke() {
    return _userRepository.signInWithGoogle();
  }
}