
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/domain/usecase/SetCategoryUsecase.dart';
import 'package:todo_app/domain/usecase/SetToDoUsecase.dart';

class SetToDoRecordUsecase {
  final _setToDoUsecase = SetToDoUsecase();
  final _setCategoryUsecase = SetCategoryUsecase();

  Future<void> invoke(ToDoRecord toDoRecord) async {
    final categoryId = await _setCategoryUsecase.invoke(toDoRecord.category);
    return _setToDoUsecase.invoke(toDoRecord.toDo.buildNew(categoryId: categoryId));
  }
}