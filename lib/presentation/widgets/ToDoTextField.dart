
import 'package:flutter/material.dart';

class ToDoTextField extends StatefulWidget {
  final String text;
  final double topPadding;
  final bool isDone;
  final ValueChanged<String> onChanged;

  ToDoTextField({
    Key key,
    this.text,
    this.topPadding = 0,
    this.isDone = false,
    this.onChanged,
  }): super(key: key);

  @override
  State createState() {
    return _ToDoTextFieldState();
  }

}

class _ToDoTextFieldState extends State<ToDoTextField> {
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

    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding),
      child: Dismissible(
        key: Key(widget.text), // todo: text가 동일할 수 있기 때문에 다른 값으로 key 만들어야함
        background: Container(color: Colors.red,),
        child: Row(
          children: <Widget>[
            widget.isDone ? Icon(
              Icons.check,
              size: 24,
              color: Colors.green,
            ) : DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: SizedBox(width: 20, height: 20,),
            ),
            SizedBox(width: 5),
            Expanded(
              child: TextField(
                controller: controller,
                style: widget.isDone ? TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  decorationStyle: TextDecorationStyle.dashed,
                ) : TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                ),
                maxLines: null,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
