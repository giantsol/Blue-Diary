import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:vibration/vibration.dart';

class VirtualKeyboard extends StatelessWidget {
  final void Function(VirtualKeyboardKey key) onKeyPressed;

  VirtualKeyboard({
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '1', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '2', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '3', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '4', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '5', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '6', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '7', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '8', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '9', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: '0', type: VirtualKeyboardKeyType.NUMBER)),
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
                        onTap: () => _onKeyPressed(VirtualKeyboardKey(text: 'backspace', type: VirtualKeyboardKeyType.BACKSPACE)),
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

  Future<void> _onKeyPressed(VirtualKeyboardKey key) async {
    onKeyPressed(key);

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        duration: 50,
        amplitude: 64,
      );
    }
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
