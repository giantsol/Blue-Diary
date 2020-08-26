
abstract class PrefsRepository {
  Future<String> getUserPassword();
  Future<void> setUserPassword(String password);
  Future<bool> getUseLockScreen();
  Future<void> setUseLockScreen(bool value);
  Future<bool> getUserCheckedToDoBefore();
  Future<void> setUserCheckedToDoBefore();
  Future<bool> hasShownWeekScreenTutorial();
  Future<void> setShownWeekScreenTutorial();
  Future<bool> hasShownDayScreenTutorial();
  Future<void> setShownDayScreenTutorial();
  Future<String> getRealFirstLaunchDateString();
  Future<void> setRealFirstLaunchDate(DateTime date);
  Future<bool> getUseRealFirstLaunchDate();
  Future<String> getCustomFirstLaunchDateString();
  Future<void> setCustomFirstLaunchDate(DateTime date);
  Future<String> getFirstLaunchDateString();
  Future<bool> hasShownFirstCompletableDayTutorial();
  Future<void> setShownFirstCompletableDayTutorial();
  Future<void> addSeed(int count);
  Future<void> minusSeed(int count);
  Future<int> getSeedCount();
  Future<int> getLastUpdatedMyRankingUserInfoLocalTimeMillis();
  Future<void> setLastUpdatedMyRankingUserInfoLocalTimeMillis(int value);
}