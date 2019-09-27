
abstract class PrefsRepository {
  Future<String> getUserPassword();
  Future<bool> setUserPassword(String password);
}