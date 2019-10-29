
abstract class PrefsRepository {
  Future<String> getUserPassword();
  Future<void> setUserPassword(String password);
  Future<bool> getUseLockScreen();
  Future<void> setUseLockScreen(bool value);
  Future<String> getRecoveryEmail();
  Future<bool> getUserCheckedToDoBefore();
  void setUserCheckedToDoBefore();
  Future<bool> hasShownWeekScreenTutorial();
  void setShownWeekScreenTutorial();
  Future<bool> hasShownDayScreenTutorial();
  void setShownDayScreenTutorial();
}