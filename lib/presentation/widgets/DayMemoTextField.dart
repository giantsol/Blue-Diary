
import 'package:flutter/material.dart';

class DayMemoTextField extends StatefulWidget {
  final FocusNode focusNode;
  final String text;
  final ValueChanged<String> onChanged;

  DayMemoTextField({
    Key key,
    this.focusNode,
    this.text,
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

    return SizedBox(
      height: 91,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TextField(
          focusNode: widget.focusNode,
          controller: controller,
          style: TextStyle(fontSize: 14),
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

}
