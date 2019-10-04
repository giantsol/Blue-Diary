
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/ToDo.dart';

class ToDoRecord {
  final ToDo toDo;
  final Category category;

  // 헿.. 아주 간단한 체크 로직
  bool get isValid => toDo.year != 0;

  const ToDoRecord({
    this.toDo = const ToDo(),
    this.category = const Category(),
  });

  ToDoRecord buildNew({
    ToDo toDo,
    Category category,
  }) {
    return ToDoRecord(
      toDo: toDo ?? this.toDo,
      category: category ?? this.category,
    );
  }
}