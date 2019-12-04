
import 'package:todo_app/presentation/App.dart';

class SignInWithGoogleUsecase {
  final _userRepository = dependencies.userRepository;

  Future<bool> invoke() {
    return _userRepository.signInWithGoogle();
  }
}