
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordBloc.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordState.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

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

  Widget _buildUI(InputPasswordState state) {
    return Material(
      color: AppColors.PRIMARY,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  _CloseButton(
                    bloc: _bloc,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          state.showErrorMsg ? AppLocalizations.of(context).retryInputPassword : AppLocalizations.of(context).inputPassword,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.TEXT_WHITE,
                            decorationStyle: null,
                          ),
                        ),
                        !state.showErrorMsg ? Column(
                          children: <Widget>[
                            SizedBox(height: 73,),
                            _Passwords(
                              passwordLength: state.password.length,
                            ),
                          ],
                        ) : Column(
                          children: <Widget>[
                            SizedBox(height: 8,),
                            Text(
                              '${AppLocalizations.of(context).confirmPasswordFail} (${state.failCount}/${InputPasswordState.MAX_FAIL_COUNT})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 48,),
                            _Passwords(
                              passwordLength: state.password.length,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  state.isLoading ? Center(child: CircularProgressIndicator(),) : const SizedBox.shrink(),
                ],
              ),
            ),
            Container(
              color: AppColors.BACKGROUND_WHITE,
              child: VirtualKeyboard(
                fontSize: 18,
                type: VirtualKeyboardType.Numeric,
                onKeyPress: (key) => _bloc.onVirtualKeyPressed(context, key, widget.onSuccess, widget.onFail),
              ),
            )
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
          child: Image.asset('assets/ic_close.png'),
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
            padding: i > 0 ? const EdgeInsets.only(left: 12) : const EdgeInsets.all(0),
            child: SizedBox(
              width: 19,
              child: Center(
                child: i <= passwordLength - 1 ? Image.asset('assets/ic_circle_white.png') : Image.asset('assets/ic_underline.png'),
              ),
            ),
          );
        }),
      ),
    );
  }
}