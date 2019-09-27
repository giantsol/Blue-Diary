class InputPasswordState {
  static const MAX_FAIL_COUNT = 5;

  final String password;
  final int failCount;
  final bool isLoading;

  String get title => failCount == 0 ? '비밀번호 입력' : '다시 입력해 주세요.';
  String get errorMsg => failCount == 0 ? '' : '일치하지 않습니다. ($failCount/$MAX_FAIL_COUNT)';

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
