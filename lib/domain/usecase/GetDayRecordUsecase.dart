
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/usecase/GetDayMemoUsecase.dart';
import 'package:todo_app/domain/usecase/GetToDoRecordsUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';

class GetDayRecordUsecase {
  final _getTodayUsecase = GetTodayUsecase();
  final _getToDoRecordsUsecase = GetToDoRecordsUsecase();
  final _getDayMemoUsecase = GetDayMemoUsecase();

  Future<DayRecord> invoke(DateTime date) async {
    final today = await _getTodayUsecase.invoke();
    final toDoRecords = await _getToDoRecordsUsecase.invoke(date);
    final dayMemo = await _getDayMemoUsecase.invoke(date);
    return DayRecord(
      toDoRecords: toDoRecords,
      dayMemo: dayMemo,
      isToday: Utils.isSameDay(date, today),
    );
  }
}