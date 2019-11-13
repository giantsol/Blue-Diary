
abstract class UserRepository {
  Future<String> getUserDisplayName();
  Future<bool> signInWithGoogle();
  Future<bool> signInWithFacebook();
  Future<bool> signOut();
}