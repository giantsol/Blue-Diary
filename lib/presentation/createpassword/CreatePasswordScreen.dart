
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordBloc.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordState.dart';
import 'package:todo_app/presentation/widgets/VirtualKeyboard.dart';

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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          state.phase == CreatePasswordPhase.FIRST ? AppLocalizations.of(context).newPassword
                            : AppLocalizations.of(context).confirmNewPassword,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.TEXT_BLACK,
                          ),
                        ),
                        SizedBox(height: 16,),
                        SizedBox(
                          height: 101,
                          child: state.errorMsg.isNotEmpty ? Text(
                            state.errorMsg,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.RED,
                            ),
                          ) : const SizedBox.shrink(),
                        ),
                        _Passwords(
                          passwordLength: state.phase == CreatePasswordPhase.FIRST ? state.password.length
                            : state.passwordConfirm.length,
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
