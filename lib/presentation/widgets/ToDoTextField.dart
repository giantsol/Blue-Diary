
import 'package:flutter/material.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class ToDoTextField extends StatefulWidget {
  final FocusNode focusNode;
  final ToDo toDo;
  final ValueChanged<String> onChanged;
  final Function onCheckBoxClicked;
  final Function onDismissed;

  ToDoTextField({
    Key key,
    this.focusNode,
    this.toDo,
    this.onChanged,
    this.onCheckBoxClicked,
    this.onDismissed,
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
    final toDo = widget.toDo;
    final controller = TextEditingController.fromValue(
      _value?.copyWith(text: toDo.content) ?? TextEditingValue(text: toDo.content),
    );

    controller.addListener(() {
      _value = controller.value;
      widget.onChanged(_value.text);
    });

    return Dismissible(
      key: Key(toDo.key),
      direction: DismissDirection.startToEnd,
      background: Container(color: Colors.red,),
      onDismissed: (_) => widget.onDismissed(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12,),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: widget.onCheckBoxClicked,
              child: toDo.isDone ? Icon(
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
            ),
            SizedBox(width: 5),
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
                controller: controller,
                style: toDo.isDone ? TextStyle(
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
