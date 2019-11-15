
class RankingUserInfo {
  static const KEY_NAME = 'name';
  static const KEY_COMPLETION_RATIO = 'completion_ratio';
  static const KEY_LATEST_STREAK = 'latest_streak';
  static const KEY_MAX_STREAK = 'max_streak';

  static RankingUserInfo fromMap(Map<String, dynamic> map) {
    return RankingUserInfo(
      name: map[KEY_NAME],
      completionRatio: map[KEY_COMPLETION_RATIO] * 1.0, // need this to convert to double..
      latestStreak: map[KEY_LATEST_STREAK],
      maxStreak: map[KEY_MAX_STREAK],
    );
  }

  final String name;
  final double completionRatio;
  final int latestStreak;
  final int maxStreak;

  const RankingUserInfo({
    this.name = '',
    this.completionRatio = 0,
    this.latestStreak = 0,
    this.maxStreak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      KEY_NAME: name,
      KEY_COMPLETION_RATIO: completionRatio,
      KEY_LATEST_STREAK: latestStreak,
      KEY_MAX_STREAK: maxStreak,
    };
  }
}