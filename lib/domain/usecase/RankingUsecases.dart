
import 'package:todo_app/domain/repository/UserRepository.dart';

class RankingUsecases {
  final UserRepository _userRepository;

  const RankingUsecases(this._userRepository);

  Future<String> getUserDisplayName() {
    return _userRepository.getUserDisplayName();
  }

  Future<bool> signInWithGoogle() {
    return _userRepository.signInWithGoogle();
  }

  Future<bool> signOut() {
    return _userRepository.signOut();
  }
}