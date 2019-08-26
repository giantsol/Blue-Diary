import 'package:flutter/material.dart';
import 'package:todo_app/presentation/widgets/BlackCircle.dart';

class WeekMemoTextField extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;

  WeekMemoTextField({
    Key key,
    this.text,
    this.onChanged,
  }): super(key: key);

  @override
  State createState() {
    return _WeekMemoTextFieldState();
  }

}

class _WeekMemoTextFieldState extends State<WeekMemoTextField> {
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

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 34,
      ),
      child: Row(
        children: <Widget>[
          BlackCircle(size: 4),
          SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 14),
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                border: InputBorder.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

}
