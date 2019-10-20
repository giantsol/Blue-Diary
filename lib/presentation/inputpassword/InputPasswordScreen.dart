
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordBloc.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordState.dart';
import 'package:todo_app/presentation/widgets/VirtualKeyboard.dart';

class InputPasswordScreen extends StatefulWidget {
  final void Function() onSuccess;
  final void Function() onFail;

  InputPasswordScreen({
    Key key,
    this.onSuccess,
    this.onFail,
}): super(key: key);

  @override
  State createState() => _InputPasswordScreenState();
}

class _InputPasswordScreenState extends State<InputPasswordScreen> {
  InputPasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = InputPasswordBloc();
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

  Widget _buildUI(InputPasswordState state) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          state.showErrorMsg ? AppLocalizations.of(context).retryInputPassword : AppLocalizations.of(context).inputPassword,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.TEXT_BLACK,
                          ),
                        ),
                        SizedBox(height: 16,),
                        SizedBox(
                          height: 101,
                          child: state.showErrorMsg ? Text(
                            '${AppLocalizations.of(context).confirmPasswordFail} (${state.failCount}/${InputPasswordState.MAX_FAIL_COUNT})',
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
                  onKeyPressed: (VirtualKeyboardKey key) => _bloc.onVirtualKeyPressed(context, key, widget.onSuccess, widget.onFail),
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
            _CloseButton(
              bloc: _bloc,
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final InputPasswordBloc bloc;

  _CloseButton({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.all(22),
          child: Image.asset('assets/ic_close_black.png'),
        ),
        onTap: () => bloc.onCloseClicked(context),
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

