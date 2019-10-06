
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordBloc.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordState.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

class CreatePasswordScreen extends StatefulWidget {
  @override
  State createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  CreatePasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CreatePasswordBloc();
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

  Widget _buildUI(CreatePasswordState state) {
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
                          state.phase == CreatePasswordPhase.FIRST ? AppLocalizations.of(context).newPassword
                            : AppLocalizations.of(context).confirmNewPassword,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.TEXT_WHITE,
                            decorationStyle: null,
                          ),
                        ),
                        state.errorMsg.isEmpty ? Column(
                          children: <Widget>[
                            SizedBox(height: 73,),
                            _Passwords(
                              passwordLength: state.passwordLength,
                            ),
                          ],
                        ) : Column(
                          children: <Widget>[
                            SizedBox(height: 8,),
                            Text(
                              state.errorMsg,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 48,),
                            _Passwords(
                              passwordLength: state.passwordLength,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: VirtualKeyboard(
                fontSize: 18,
                type: VirtualKeyboardType.Numeric,
                onKeyPress: (key) => _bloc.onVirtualKeyPressed(context, key),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final CreatePasswordBloc bloc;

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
