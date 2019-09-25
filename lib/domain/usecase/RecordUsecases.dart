
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class RecordUsecases {
  final MemoRepository _memoRepository;
  final DateRepository _dateRepository;
  final ToDoRepository _toDoRepository;

  const RecordUsecases(this._memoRepository, this._dateRepository, this._toDoRepository);

  saveWeekMemo(WeekMemo weekMemo) {
    _memoRepository.saveWeekMemo(weekMemo);
  }

  Future<List<WeekMemo>> getCurrentWeekMemos() async {
    return await _memoRepository.getWeekMemos(_dateRepository.getCurrentDate());
  }

  changeCurrentDateByDay(int day) {
    _dateRepository.setCurrentDate(_dateRepository.getCurrentDate().add(Duration(days: day)));
  }

  DateInWeek getCurrentDateInWeek() {
    final currentDate = _dateRepository.getCurrentDate();
    return DateInWeek.fromDate(currentDate);
  }

  Future<DayRecord> getCurrentDayRecord() async {
    final today = _dateRepository.getToday();
    final currentDate = _dateRepository.getCurrentDate();
    final toDos = await _toDoRepository.getToDos(currentDate);
    final dayMemo = await _memoRepository.getDayMemo(currentDate);
    return DayRecord(currentDate, toDos, dayMemo, Utils.isSameDay(currentDate, today), true);
  }

  Future<DayRecord> getPrevDayRecord() async {
    final today = _dateRepository.getToday();
    final prevDate = _dateRepository.getCurrentDate().subtract(Duration(days: 1));
    final toDos = await _toDoRepository.getToDos(prevDate);
    final dayMemo = await _memoRepository.getDayMemo(prevDate);
    return DayRecord(prevDate, toDos, dayMemo, Utils.isSameDay(prevDate, today), false);
  }

  Future<DayRecord> getNextDayRecord() async {
    final today = _dateRepository.getToday();
    final nextDate = _dateRepository.getCurrentDate().add(Duration(days: 1));
    final toDos = await _toDoRepository.getToDos(nextDate);
    final dayMemo = await _memoRepository.getDayMemo(nextDate);
    return DayRecord(nextDate, toDos, dayMemo, Utils.isSameDay(nextDate, today), false);
  }

  DateTime getToday() {
    return _dateRepository.getToday();
  }

  saveToDo(ToDo toDo) {
    _toDoRepository.saveToDo(toDo);
  }

  removeToDo(ToDo toDo) {
    _toDoRepository.removeToDo(toDo);
  }

  saveDayMemo(DayMemo dayMemo) {
    _memoRepository.saveDayMemo(dayMemo);
  }

  setCurrentDateToToday() {
    _dateRepository.setCurrentDate(_dateRepository.getToday());
  }

}