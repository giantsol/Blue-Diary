
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/lock/LockBloc.dart';
import 'package:todo_app/presentation/lock/LockState.dart';

class LockScreen extends StatefulWidget {
  @override
  State createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  LockBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LockBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  Widget _buildUI(LockState state) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/ic_lock_logo.png'),
                      SizedBox(height: 16,),
                      SizedBox(
                        height: 64,
                        child: state.failCount > 0 ? Text(
                          '${AppLocalizations.of(context).confirmPasswordFail} (${state.failCount}/${LockState.MAX_FAIL_COUNT})',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.RED,
                          ),
                        ) : const SizedBox.shrink(),
                      ),
                      _Passwords(
                        passwordLength: state.password.length,
                      ),
                    ],
                  ),
                ),
              ),
              _VirtualKeyboard(
                onKeyPressed: (VirtualKeyboardKey key) => _bloc.onVirtualKeyPressed(context, key),
              ),
              SizedBox(height: 4,),
              Center(
                child: Text(
                  AppLocalizations.of(context).forgotYourPassword,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.TEXT_BLACK_LIGHT,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.TEXT_BLACK_LIGHT,
                    decorationThickness: 2,
                  ),
                ),
              ),
              SizedBox(height: 24,),
            ],
          ),
        ),
      ),
    );
  }
}

class _Passwords extends StatelessWidget {
  final int passwordLength;

  _Passwords({
    @required this.passwordLength,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (i) {
          return Padding(
            padding: i > 0 ? const EdgeInsets.only(left: 33) : const EdgeInsets.all(0),
            child: SizedBox(
              width: 19,
              child: Center(
                child: i <= passwordLength - 1 ? Image.asset('assets/ic_password.png') : Image.asset('assets/ic_password_blank.png'),
              )
            )
          );
        }),
      ),
    );
  }
}

class VirtualKeyboardKey {
  final String text;
  final VirtualKeyboardKeyType type;

  VirtualKeyboardKey({
    @required this.text,
    @required this.type,
  });
}

enum VirtualKeyboardKeyType {
  NUMBER,
  BACKSPACE
}

class _VirtualKeyboard extends StatelessWidget {
  final void Function(VirtualKeyboardKey key) onKeyPressed;

  _VirtualKeyboard({
    @required this.onKeyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: AppColors.PRIMARY),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,),
        child: SizedBox(
          height: 304,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '1', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '2', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '3', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '4', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '4',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '5', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '5',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '6', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '6',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '7', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '7',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '8', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '8',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '9', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '9',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: '0', type: VirtualKeyboardKeyType.NUMBER)),
                        child: Center(
                          child: Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.TEXT_BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => onKeyPressed(VirtualKeyboardKey(text: 'backspace', type: VirtualKeyboardKeyType.BACKSPACE)),
                        child: Center(
                          child: Image.asset('assets/ic_backspace.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
