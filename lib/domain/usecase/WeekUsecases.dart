
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';

class WeekUsecases {
  final MemoRepository _memoRepository;
  final DateRepository _dateRepository;
  final ToDoRepository _toDoRepository;
  final LockRepository _lockRepository;
  final PrefsRepository _prefsRepository;

  const WeekUsecases(this._memoRepository, this._dateRepository, this._toDoRepository, this._lockRepository, this._prefsRepository);

  DateTime getCurrentDate() {
    return _dateRepository.getCurrentDate();
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
    final dateInWeek = DateInWeek.fromDate(date);
    final isCheckPointsLocked = await _lockRepository.getIsCheckPointsLocked(date);
    final checkPoints = await _memoRepository.getCheckPoints(date);

    final datesInWeek = Utils.getDatesInWeek(date);
    List<DayRecord> dayRecords = [];
    for (int i = 0; i < datesInWeek.length; i++) {
      final date = datesInWeek[i];
      final toDos = await _toDoRepository.getToDos(date);
      final isLocked = await _lockRepository.getIsDayRecordLocked(date);
      final dayMemo = await _memoRepository.getDayMemo(date);
      final dayRecord = DayRecord(
        date: date,
        toDos: toDos,
        isLocked: isLocked,
        isToday: Utils.isSameDay(date, today),
        dayMemo: dayMemo,
      );
      dayRecords.add(dayRecord);
    }

    return WeekRecord(dateInWeek: dateInWeek, isCheckPointsLocked: isCheckPointsLocked, checkPoints: checkPoints, dayRecords: dayRecords);
  }

  void setCheckPoint(CheckPoint checkPoint) {
    _memoRepository.setCheckPoint(checkPoint);
  }

  void setCurrentDateToToday() {
    _dateRepository.setCurrentDate(_dateRepository.getToday());
  }

  void setCheckPointsLocked(DateInWeek dateInWeek, bool value) {
    _lockRepository.setIsCheckPointsLocked(dateInWeek, value);
  }

  void setDayRecordLocked(DateTime date, bool value) {
    _lockRepository.setIsDayRecordLocked(date, value);
  }

  void setCurrentDateToNextWeek() {
    _dateRepository.setCurrentDate(_dateRepository.getCurrentDate().add(Duration(days: 7)));
  }

  void setCurrentDateToPrevWeek() {
    _dateRepository.setCurrentDate(_dateRepository.getCurrentDate().subtract(Duration(days: 7)));
  }

  Future<String> getUserPassword() async {
    return _prefsRepository.getUserPassword();
  }
}