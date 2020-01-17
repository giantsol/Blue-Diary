
import 'package:todo_app/presentation/App.dart';

class SetUserDisplayNameUsecase {
  final _userRepository = dependencies.userRepository;

  Future<bool> invoke(String uid, String newName) {
    return _userRepository.setUserDisplayName(uid, newName);
  }
}