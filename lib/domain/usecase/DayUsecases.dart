
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class DayUsecases {
  final ToDoRepository _toDoRepository;
  final CategoryRepository _categoryRepository;
  final MemoRepository _memoRepository;
  final PrefsRepository _prefsRepository;
  final DateRepository _dateRepository;

  const DayUsecases(this._toDoRepository, this._categoryRepository, this._memoRepository, this._prefsRepository, this._dateRepository);

  Future<DayRecord> getDayRecord(DateTime date) async {
    final today = await _dateRepository.getToday();
    final toDoRecords = await getToDoRecords(date);
    final dayMemo = await getDayMemo(date);
    return DayRecord(
      toDoRecords: toDoRecords,
      dayMemo: dayMemo,
      isToday: Utils.isSameDay(date, today),
    );
  }

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

  Future<int> setCategory(Category category) async {
    return await _categoryRepository.setCategory(category);
  }

  Future<String> getUserPassword() async {
    return await _prefsRepository.getUserPassword();
  }

  Future<bool> getUserCheckedToDoBefore() async {
    return await _prefsRepository.getUserCheckedToDoBefore();
  }

  void setUserCheckedToDoBefore() {
    _prefsRepository.setUserCheckedToDoBefore();
  }

  Future<bool> hasShownDayScreenTutorial() async {
    return _prefsRepository.hasShownDayScreenTutorial();
  }

  void setShownDayScreenTutorial() {
    _prefsRepository.setShownDayScreenTutorial();
  }

  Future<bool> hasDayBeenMarkedCompleted(DateTime date) {
    return _toDoRepository.hasDayBeenMarkedCompleted(date);
  }
}