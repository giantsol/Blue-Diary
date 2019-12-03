
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/SetCategoryUsecase.dart';
import 'package:todo_app/domain/usecase/SetToDoUsecase.dart';

class SetToDoRecordUsecase {
  final SetToDoUsecase _setToDoUsecase;
  final SetCategoryUsecase _setCategoryUsecase;

  SetToDoRecordUsecase(ToDoRepository toDoRepository, CategoryRepository categoryRepository)
  : _setToDoUsecase = SetToDoUsecase(toDoRepository),
    _setCategoryUsecase = SetCategoryUsecase(categoryRepository);

  Future<void> invoke(ToDoRecord toDoRecord) async {
    final categoryId = await _setCategoryUsecase.invoke(toDoRecord.category);
    return _setToDoUsecase.invoke(toDoRecord.toDo.buildNew(categoryId: categoryId));
  }
}