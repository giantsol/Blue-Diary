
import 'package:todo_app/presentation/App.dart';

class IsSignedInUsecase {
  final _userRepository = dependencies.userRepository;

  Future<bool> invoke() async {
    return (await _userRepository.getUserId()).isNotEmpty;
  }
}