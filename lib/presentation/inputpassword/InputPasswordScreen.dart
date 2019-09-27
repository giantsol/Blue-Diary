
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordBloc.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordState.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

class InputPasswordScreen extends StatefulWidget {
  final Function() onSuccess;
  final Function() onFail;

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
      color: AppColors.primary,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(22),
                        child: Image.asset('assets/ic_close.png'),
                      ),
                      onTap: () => _bloc.onCloseClicked(context),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          state.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textWhite,
                            decorationStyle: null,
                          ),
                        ),
                        state.errorMsg.isEmpty
                          ? Column(
                          children: <Widget>[
                            SizedBox(height: 73,),
                            _buildPasswords(state),
                          ],
                        )
                          : Column(
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
                            _buildPasswords(state),
                          ],
                        ),
                      ],
                    ),
                  ),
                  state.isLoading ? Center(child: CircularProgressIndicator(),) : Container(),
                ],
              ),
            ),
            Container(
              color: Colors.white,
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

  Widget _buildPasswords(InputPasswordState state) {
    final passwordLength = state.password.length;
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
