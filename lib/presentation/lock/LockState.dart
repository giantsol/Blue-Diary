
class LockState {
  static const MAX_FAIL_COUNT = 5;

  final int failCount;
  final String password;

  const LockState({
    this.failCount = 0,
    this.password = '',
  });

  LockState buildNew({
    int failCount,
    String password,
  }) {
    return LockState(
      failCount: failCount ?? this.failCount,
      password: password ?? this.password,
    );
  }
}