
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class GetToDoRecordsUsecase {
  final ToDoRepository _toDoRepository;
  final CategoryRepository _categoryRepository;

  GetToDoRecordsUsecase(this._toDoRepository, this._categoryRepository);

  Future<List<ToDoRecord>> invoke(DateTime date) async {
    final List<ToDoRecord> toDoRecords = [];
    final toDos = await _toDoRepository.getToDos(date);
    for (final toDo in toDos) {
      final category = await _categoryRepository.getCategory(toDo.categoryId);
      toDoRecords.add(ToDoRecord(
        toDo: toDo,
        category: category,
      ));
    }
    return toDoRecords;
  }
}