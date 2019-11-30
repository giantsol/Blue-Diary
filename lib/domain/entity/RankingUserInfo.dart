
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/entity/Pets.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';

class RankingUserInfo {
  static const KEY_UID = 'uid';
  static const KEY_NAME = 'name';
  static const KEY_FIRST_LAUNCH_DATE_MILLIS = 'first_launch_date_millis';
  static const KEY_COMPLETED_DAYS_COUNT = 'completed_days_count';
  static const KEY_COMPLETION_RATIO = 'completion_ratio';
  static const KEY_LATEST_STREAK = 'latest_streak';
  static const KEY_LATEST_STREAK_END_MILLIS = 'latest_streak_end_millis';
  static const KEY_LONGEST_STREAK = 'longest_streak';
  static const KEY_LONGEST_STREAK_END_MILLIS = 'longest_streak_end_millis';
  static const KEY_THUMBS_UP = 'thumbs_up';
  static const KEY_LAST_UPDATED_MILLIS = 'last_updated_millis';
  static const KEY_PET_KEY = 'pet_key';
  static const KEY_PET_PHASE_INDEX = 'pet_phase_index';

  static const INVALID = const RankingUserInfo();

  static RankingUserInfo fromMap(Map<String, dynamic> map) {
    return RankingUserInfo(
      uid: map[KEY_UID] ?? '',
      name: map[KEY_NAME] ?? '',
      firstLaunchDateMillis: map[KEY_FIRST_LAUNCH_DATE_MILLIS] ?? 0,
      completedDaysCount: map[KEY_COMPLETED_DAYS_COUNT] ?? 0,
      latestStreak: map[KEY_LATEST_STREAK] ?? 0,
      latestStreakEndMillis: map[KEY_LATEST_STREAK_END_MILLIS] ?? 0,
      longestStreak: map[KEY_LONGEST_STREAK] ?? 0,
      longestStreakEndMillis: map[KEY_LONGEST_STREAK_END_MILLIS] ?? 0,
      thumbsUp: map[KEY_THUMBS_UP] ?? 0,
      lastUpdatedMillis: map[KEY_LAST_UPDATED_MILLIS] ?? 0,
      petKey: map[KEY_PET_KEY] ?? '',
      petPhaseIndex: map[KEY_PET_PHASE_INDEX] ?? Pet.PHASE_INDEX_INACTIVE,
    );
  }

  final String uid;
  final String name;
  final int firstLaunchDateMillis;
  final int completedDaysCount;
  final int latestStreak;
  final int latestStreakEndMillis;
  final int longestStreak;
  final int longestStreakEndMillis;
  final int thumbsUp;
  final int lastUpdatedMillis;
  final String petKey;
  final int petPhaseIndex;

  PetPhase get petPhase {
    final pet = Pets.getPetPrototype(petKey);
    if (pet == Pet.INVALID) {
      return PetPhase.INVALID;
    } else {
      return petPhaseIndex == Pet.PHASE_INDEX_INACTIVE ? PetPhase.INVALID
        : petPhaseIndex == Pet.PHASE_INDEX_EGG ? pet.eggPhase
        : pet.bornPhases[petPhaseIndex];
    }
  }

  DateTime get latestStreakStartDate {
    if (latestStreakEndMillis == 0) {
      return DateRepository.INVALID_DATE;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(latestStreakEndMillis).subtract(Duration(days: latestStreak - 1));
    }
  }

  DateTime get latestStreakEndDate {
    if (latestStreakEndMillis == 0) {
      return DateRepository.INVALID_DATE;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(latestStreakEndMillis);
    }
  }

  DateTime get longestStreakStartDate {
    if (longestStreakEndMillis == 0) {
      return DateRepository.INVALID_DATE;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(longestStreakEndMillis).subtract(Duration(days: longestStreak - 1));
    }
  }

  DateTime get longestStreakEndDate {
    if (longestStreakEndMillis == 0) {
      return DateRepository.INVALID_DATE;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(longestStreakEndMillis);
    }
  }

  const RankingUserInfo({
    this.uid = '',
    this.name = '',
    this.firstLaunchDateMillis = 0,
    this.completedDaysCount = 0,
    this.latestStreak = 0,
    this.latestStreakEndMillis = 0,
    this.longestStreak = 0,
    this.longestStreakEndMillis = 0,
    this.thumbsUp = 0,
    this.lastUpdatedMillis = 0,
    this.petKey = '',
    this.petPhaseIndex = Pet.PHASE_INDEX_INACTIVE,
  });

  String getCompletionRatioPercentageString(DateTime today) {
    if (firstLaunchDateMillis == 0) {
      return '0.0';
    } else {
      final startDate = DateTime.fromMillisecondsSinceEpoch(firstLaunchDateMillis);
      final ratio = completedDaysCount.toDouble() / (today.difference(startDate).inDays + 1);
      return (ratio * 100).toStringAsFixed(1);
    }
  }

  RankingUserInfo buildNew({
    int thumbsUp,
  }) {
    return RankingUserInfo(
      uid: this.uid,
      name: this.name,
      firstLaunchDateMillis: this.firstLaunchDateMillis,
      completedDaysCount: this.completedDaysCount,
      latestStreak: this.latestStreak,
      latestStreakEndMillis: this.latestStreakEndMillis,
      longestStreak: this.longestStreak,
      longestStreakEndMillis: this.longestStreakEndMillis,
      thumbsUp: thumbsUp ?? this.thumbsUp,
      lastUpdatedMillis: this.lastUpdatedMillis,
      petKey: this.petKey,
      petPhaseIndex: this.petPhaseIndex,
    );
  }

  Map<String, dynamic> toMyRankingUserInfoUpdateMap() {
    return {
      KEY_UID: uid,
      KEY_NAME: name,
      KEY_FIRST_LAUNCH_DATE_MILLIS: firstLaunchDateMillis,
      KEY_COMPLETED_DAYS_COUNT: completedDaysCount,
      KEY_LATEST_STREAK: latestStreak,
      KEY_LATEST_STREAK_END_MILLIS: latestStreakEndMillis,
      KEY_LONGEST_STREAK: longestStreak,
      KEY_LONGEST_STREAK_END_MILLIS: longestStreakEndMillis,
      KEY_PET_KEY: petKey,
      KEY_PET_PHASE_INDEX: petPhaseIndex,
    };
  }

  Map<String, dynamic> toThumbsUpUpdateMap() {
    return {
      KEY_THUMBS_UP: thumbsUp,
    };
  }
}