
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class DayUsecases {
  final ToDoRepository _toDoRepository;
  final CategoryRepository _categoryRepository;
  final MemoRepository _memoRepository;

  const DayUsecases(this._toDoRepository, this._categoryRepository, this._memoRepository);

  Future<List<ToDoRecord>> getToDoRecords(DateTime date) async {
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

  void setDayMemo(DayMemo dayMemo) {
    _memoRepository.setDayMemo(dayMemo);
  }

  void setToDo(ToDo toDo) {
    _toDoRepository.setToDo(toDo);
  }

  Future<DayMemo> getDayMemo(DateTime date) async {
    return _memoRepository.getDayMemo(date);
  }

  Future<void> setToDoRecord(ToDoRecord toDoRecord) async {
    final categoryId = await _categoryRepository.setCategory(toDoRecord.category);
    _toDoRepository.setToDo(toDoRecord.toDo.buildNew(categoryId: categoryId));
  }

  void removeToDo(ToDo toDo) {
    _toDoRepository.removeToDo(toDo);
  }

  Future<List<Category>> getAllCategories() async {
    return _categoryRepository.getAllCategories();
  }

  Future<void> removeCategory(Category category) async {
    return _categoryRepository.removeCategory(category);
  }
}