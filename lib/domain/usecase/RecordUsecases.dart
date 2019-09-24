
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class RecordUsecases {
  final MemoRepository _memoRepository;
  final DateRepository _dateRepository;
  final ToDoRepository _toDoRepository;
  final LockRepository _lockRepository;

  const RecordUsecases(this._memoRepository, this._dateRepository, this._toDoRepository, this._lockRepository);

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

  Future<WeekRecord> getCurrentWeekRecord() async {
    return _getWeekRecord(_dateRepository.getCurrentDate());
  }

  Future<WeekRecord> getPrevWeekRecord() async {
    return _getWeekRecord(_dateRepository.getCurrentDate().subtract(Duration(days: 7)));
  }

  Future<WeekRecord> getNextWeekRecord() async {
    return _getWeekRecord(_dateRepository.getCurrentDate().add(Duration(days: 7)));
  }

  Future<WeekRecord> _getWeekRecord(DateTime date) async {
    final today = _dateRepository.getToday();
    final isCheckPointsLocked = await _lockRepository.getIsCheckPointsLocked(date);
    final checkPoints = await _memoRepository.getCheckPoints(date);

    final datesInWeek = DateInWeek.fromDate(date).datesInWeek;
    List<DayPreview> dayPreviews = [];
    for (int i = 0; i < datesInWeek.length; i++) {
      final date = datesInWeek[i];
      final toDos = await _toDoRepository.getToDos(date);
      final isLocked = await _lockRepository.getIsDayRecordLocked(date);
      dayPreviews.add(DayPreview(date, toDos, isLocked, i < datesInWeek.length - 1, Utils.isSameDay(date, today)));
    }

    return WeekRecord(isCheckPointsLocked, checkPoints, dayPreviews);
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