
class LockState {
  static const MAX_FAIL_COUNT = 5;

  final int failCount;
  final String password;
  final String animationName;

  const LockState({
    this.failCount = 0,
    this.password = '',
    this.animationName = '',
  });

  LockState buildNew({
    int failCount,
    String password,
    String animationName,
  }) {
    return LockState(
      failCount: failCount ?? this.failCount,
      password: password ?? this.password,
      animationName: animationName ?? this.animationName,
    );
  }
}