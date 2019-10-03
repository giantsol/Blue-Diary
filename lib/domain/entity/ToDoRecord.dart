
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class ToDoRecord {
  final ToDo toDo;
  final Category category;

  const ToDoRecord({
    this.toDo = const ToDo(),
    this.category = const Category(),
  });
}