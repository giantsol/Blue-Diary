
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/entity/Pets.dart';

class RankingUserInfo {
  static const KEY_UID = 'uid';
  static const KEY_NAME = 'name';
  static const KEY_COMPLETION_RATIO = 'completion_ratio';
  static const KEY_LATEST_STREAK = 'latest_streak';
  static const KEY_LONGEST_STREAK = 'longest_streak';
  static const KEY_THUMBS_UP = 'thumbs_up';
  static const KEY_LAST_UPDATED = 'last_updated';
  static const KEY_PET_KEY = 'pet_key';
  static const KEY_PET_PHASE_INDEX = 'pet_phase_index';

  static const INVALID = const RankingUserInfo();

  static RankingUserInfo fromMap(Map<String, dynamic> map) {
    return RankingUserInfo(
      uid: map[KEY_UID] ?? '',
      name: map[KEY_NAME] ?? '',
      completionRatio: map[KEY_COMPLETION_RATIO] * 1.0 ?? 0.0, // need this to convert to double..
      latestStreak: map[KEY_LATEST_STREAK] ?? 0,
      longestStreak: map[KEY_LONGEST_STREAK] ?? 0,
      thumbsUp: map[KEY_THUMBS_UP] ?? 0,
      lastUpdated: map[KEY_LAST_UPDATED] ?? 0,
      petKey: map[KEY_PET_KEY] ?? '',
      petPhaseIndex: map[KEY_PET_PHASE_INDEX] ?? Pet.PHASE_INDEX_INACTIVE,
    );
  }

  final String uid;
  final String name;
  final double completionRatio;
  final int latestStreak;
  final int longestStreak;
  final int thumbsUp;
  final int lastUpdated;
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

  const RankingUserInfo({
    this.uid = '',
    this.name = '',
    this.completionRatio = 0,
    this.latestStreak = 0,
    this.longestStreak = 0,
    this.thumbsUp = 0,
    this.lastUpdated = 0,
    this.petKey = '',
    this.petPhaseIndex = Pet.PHASE_INDEX_INACTIVE,
  });

  Map<String, dynamic> toMap() {
    return {
      KEY_UID: uid,
      KEY_NAME: name,
      KEY_COMPLETION_RATIO: completionRatio,
      KEY_LATEST_STREAK: latestStreak,
      KEY_LONGEST_STREAK: longestStreak,
      KEY_THUMBS_UP: thumbsUp,
      KEY_LAST_UPDATED: lastUpdated,
      KEY_PET_KEY: petKey,
      KEY_PET_PHASE_INDEX: petPhaseIndex,
    };
  }
}