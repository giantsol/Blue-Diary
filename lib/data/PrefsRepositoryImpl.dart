
import 'package:flutter/foundation.dart';
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';

class PrefsRepositoryImpl implements PrefsRepository {
  final AppPreferences _prefs;

  const PrefsRepositoryImpl(this._prefs);

  @override
  Future<String> getUserPassword() {
    return _prefs.getUserPassword();
  }

  @override
  Future<void> setUserPassword(String password) {
    return _prefs.setUserPassword(password);
  }

  @override
  Future<bool> getUseLockScreen() {
    return _prefs.getUseLockScreen();
  }

  @override
  Future<void> setUseLockScreen(bool value) {
    return _prefs.setUseLockScreen(value);
  }

  @override
  Future<String> getRecoveryEmail() {
    return _prefs.getRecoveryEmail();
  }

  @override
  Future<bool> getUserCheckedToDoBefore() {
    return _prefs.getUserCheckedToDoBefore();
  }

  @override
  void setUserCheckedToDoBefore() {
    _prefs.setUserCheckedToDoBefore();
  }

  @override
  Future<bool> hasShownWeekScreenTutorial() {
    return _prefs.hasShownWeekScreenTutorial();
  }

  @override
  void setShownWeekScreenTutorial() {
    _prefs.setShownWeekScreenTutorial();
  }

  @override
  Future<bool> hasShownDayScreenTutorial() {
    return _prefs.hasShownDayScreenTutorial();
  }

  @override
  void setShownDayScreenTutorial() {
    _prefs.setShownDayScreenTutorial();
  }

  @override
  Future<String> getRealFirstLaunchDateString() {
    return _prefs.getRealFirstLaunchDateString();
  }

  @override
  void setRealFirstLaunchDate(DateTime date) {
    final trimmed = DateTime(date.year, date.month, date.day);
    _prefs.setRealFirstLaunchDateString(trimmed.toIso8601String());
  }

  @override
  Future<bool> getUseRealFirstLaunchDate() async {
    return kReleaseMode || await _prefs.getUseRealFirstLaunchDate();
  }

  @override
  Future<String> getCustomFirstLaunchDateString() {
    return _prefs.getCustomFirstLaunchDateString();
  }

  @override
  void setCustomFirstLaunchDate(DateTime date) {
    final trimmed = DateTime(date.year, date.month, date.day);
    _prefs.setCustomFirstLaunchDateString(trimmed.toIso8601String());
  }

  @override
  Future<String> getFirstLaunchDateString() async {
    final useReal = await getUseRealFirstLaunchDate();
    if (useReal) {
      return getRealFirstLaunchDateString();
    } else {
      return getCustomFirstLaunchDateString();
    }
  }

  @override
  Future<bool> hasShownFirstCompletableDayTutorial() {
    return _prefs.hasShownFirstCompletableDayTutorial();
  }

  @override
  void setShownFirstCompletableDayTutorial() {
    _prefs.setShownFirstCompletableDayTutorial();
  }

  @override
  void addSeed(int count) {
    _prefs.addSeed(count);
  }

  @override
  int getSeedCount() {
    return _prefs.getSeedCount();
  }

  @override
  int getLastUpdatedMyRankingUserInfoLocalTimeMillis() {
    return _prefs.getLastUpdatedMyRankingUserInfoLocalTimeMillis();
  }

  @override
  void setLastUpdatedMyRankingUserInfoLocalTimeMillis(int value) {
    _prefs.setLastUpdatedMyRankingUserInfoLocalTimeMillis(value);
  }
}