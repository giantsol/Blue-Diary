
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';

class DayMemoTextField extends StatefulWidget {
  final FocusNode focusNode;
  final String text;
  final String hintText;
  final ValueChanged<String> onChanged;

  DayMemoTextField({
    Key key,
    this.focusNode,
    this.text,
    this.hintText,
    this.onChanged,
  }): super(key: key);

  @override
  State createState() {
    return _DayMemoTextFieldState();
  }

}

class _DayMemoTextFieldState extends State<DayMemoTextField> {
  TextEditingValue _value;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController.fromValue(
      _value?.copyWith(text: widget.text) ?? TextEditingValue(text: widget.text),
    );

    controller.addListener(() {
      _value = controller.value;
      widget.onChanged(_value.text);
    });

    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextField(
        focusNode: widget.focusNode,
        controller: controller,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.TEXT_WHITE,
        ),
        minLines: 1,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: AppColors.TEXT_WHITE_DARK,
          )
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

}
