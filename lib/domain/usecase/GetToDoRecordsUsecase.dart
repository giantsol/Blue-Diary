
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/presentation/App.dart';

class GetToDoRecordsUsecase {
  final _toDoRepository = dependencies.toDoRepository;
  final _categoryRepository = dependencies.categoryRepository;

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