
class InputPasswordState {
  static const MAX_FAIL_COUNT = 5;

  final String password;
  final int failCount;
  final bool isLoading;

  bool get showErrorMsg => failCount > 0;

  const InputPasswordState({
    this.password = '',
    this.failCount = 0,
    this.isLoading = false,
  });

  InputPasswordState buildNew({
    String password,
    int failCount,
    bool isLoading,
  }) {
    return InputPasswordState(
      password: password ?? this.password,
      failCount: failCount ?? this.failCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
