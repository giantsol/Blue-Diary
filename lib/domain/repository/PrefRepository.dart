
abstract class PrefsRepository {
  Future<String> getUserPassword();
  Future<void> setUserPassword(String password);
  Future<bool> getDefaultLocked();
  Future<void> setDefaultLocked(bool value);
  Future<String> getRecoveryEmail();
}