
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';

class ToDoEditorTextField extends StatefulWidget {
  final FocusNode focusNode;
  final String text;
  final String hintText;
  final ValueChanged<String> onChanged;

  ToDoEditorTextField({
    Key key,
    this.focusNode,
    this.text,
    this.hintText,
    this.onChanged,
  }): super(key: key);

  @override
  State createState() {
    return _ToDoEditorTextFieldState();
  }

}

class _ToDoEditorTextFieldState extends State<ToDoEditorTextField> {
  TextEditingValue _value;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController.fromValue(
      _value?.copyWith(text: widget.text) ??
        TextEditingValue(text: widget.text),
    );

    controller.addListener(() {
      _value = controller.value;
      widget.onChanged(_value.text);
    });

    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextField(
        focusNode: widget.focusNode,
        autofocus: true,
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.TEXT_BLACK,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.TEXT_BLACK_LIGHT,
          )
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

}
