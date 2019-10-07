
abstract class PrefsRepository {
  Future<String> getUserPassword();
  Future<bool> setUserPassword(String password);
  Future<bool> getDefaultLocked();
  Future<bool> setDefaultLocked(bool value);
  Future<String> getRecoveryEmail();
}