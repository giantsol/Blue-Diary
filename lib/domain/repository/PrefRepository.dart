
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
  Future<String> getRealFirstLaunchDateString();
  void setRealFirstLaunchDate(DateTime date);
  Future<bool> getUseRealFirstLaunchDate();
  Future<String> getCustomFirstLaunchDateString();
  void setCustomFirstLaunchDate(DateTime date);
  Future<String> getFirstLaunchDateString();
  Future<bool> hasShownFirstCompletableDayTutorial();
  void setShownFirstCompletableDayTutorial();
  void addSeed(int count);
  int getSeedCount();
  int getLastUpdatedMyRankingUserInfoLocalTimeMillis();
  void setLastUpdatedMyRankingUserInfoLocalTimeMillis(int value);
  int getLastUpdatedTodayLocalTimeMillis();
  void setLastUpdatedTodayLocalTimeMillis(int value);
}