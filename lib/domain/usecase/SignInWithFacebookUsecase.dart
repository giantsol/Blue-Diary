
import 'package:todo_app/presentation/App.dart';

class SignInWithFacebookUsecase {
  final _userRepository = dependencies.userRepository;

  Future<bool> invoke() {
    return _userRepository.signInWithFacebook();
  }
}