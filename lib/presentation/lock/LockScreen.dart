
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/lock/LockBloc.dart';
import 'package:todo_app/presentation/lock/LockState.dart';
import 'package:todo_app/presentation/widgets/VirtualKeyboard.dart';

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
      child: SafeArea(
        child: Scaffold(
          body: Column(
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
                            fontSize: 14,
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
              VirtualKeyboard(
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

