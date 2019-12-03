
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/lock/LockBloc.dart';
import 'package:todo_app/presentation/lock/LockState.dart';
import 'package:todo_app/presentation/widgets/VirtualKeyboard.dart';

class LockScreen extends StatefulWidget {
  @override
  State createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  LockBloc _bloc;
  FlareControls _flareControls;

  @override
  void initState() {
    super.initState();
    _bloc = LockBloc(dependencies.prefsRepository);
    _flareControls = FlareControls();
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
    _flareControls.play(state.animationName, mix: 0);
    final errorMsg = state.failCount > 0 ? '${AppLocalizations.of(context).confirmPasswordFail} (${state.failCount}/${LockState.MAX_FAIL_COUNT})' : '';
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: FlareActor(
                          'assets/lock_screen_logo.flr',
                          controller: _flareControls,
                        ),
                      ),
                      SizedBox(height: 16,),
                      SizedBox(
                        height: 64,
                        child: errorMsg.isNotEmpty ? Text(
                          errorMsg,
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
