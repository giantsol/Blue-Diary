
class RankingState {
  final String userDisplayName;

  const RankingState({
    this.userDisplayName = '',
  });

  RankingState buildNew({
    String userDisplayName,
  }) {
    return RankingState(
      userDisplayName: userDisplayName ?? this.userDisplayName,
    );
  }
}