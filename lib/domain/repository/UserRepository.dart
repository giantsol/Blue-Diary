
abstract class UserRepository {
  Future<String> getUserDisplayName();
  Future<bool> signInWithGoogle();
  Future<bool> signOut();
}