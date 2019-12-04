
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/repository/CategoryRepository.dart';
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/repository/ToDoRepository.dart';
import 'package:todo_app/domain/usecase/GetDayMemoUsecase.dart';
import 'package:todo_app/domain/usecase/GetToDoRecordsUsecase.dart';
import 'package:todo_app/domain/usecase/GetTodayUsecase.dart';

class GetDayRecordUsecase {
  final GetTodayUsecase _getTodayUsecase;
  final GetToDoRecordsUsecase _getToDoRecordsUsecase;
  final GetDayMemoUsecase _getDayMemoUsecase;

  GetDayRecordUsecase(DateRepository dateRepository, ToDoRepository toDoRepository, CategoryRepository categoryRepository, MemoRepository memoRepository, PrefsRepository prefsRepository)
    : _getTodayUsecase = GetTodayUsecase(dateRepository, prefsRepository),
      _getToDoRecordsUsecase = GetToDoRecordsUsecase(toDoRepository, categoryRepository),
      _getDayMemoUsecase = GetDayMemoUsecase(memoRepository);

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