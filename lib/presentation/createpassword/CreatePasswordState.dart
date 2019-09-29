enum CreatePasswordPhase {
  FIRST,
  SECOND,
}

class CreatePasswordState {
  final CreatePasswordPhase phase;
  final String errorMsg;
  final String password;
  final String passwordConfirm;

  String get title => phase == CreatePasswordPhase.FIRST ? '새 비밀번호 생성' : '새 비밀번호 확인';

  const CreatePasswordState({
    this.phase = CreatePasswordPhase.FIRST,
    this.errorMsg = '',
    this.password = '',
    this.passwordConfirm = '',
  });

  CreatePasswordState buildNew({
    CreatePasswordPhase phase,
    String errorMsg,
    String password,
    String passwordConfirm,
  }) {
    return CreatePasswordState(
      phase: phase ?? this.phase,
      errorMsg: errorMsg ?? this.errorMsg,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
    );
  }
}