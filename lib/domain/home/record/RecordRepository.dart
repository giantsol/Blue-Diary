
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/ToDo.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemo.dart';

abstract class RecordRepository {
  Stream<DateTime> get currentDateTime;
  Stream<List<WeekMemo>> get weekMemos;
  Stream<List<DayRecord>> get dayRecords;

  updateSingleWeekMemo(WeekMemo weekMemo, String updated);
  updateDayRecordPageIndex(int updatedIndex);
  updateDayMemo(DayMemo dayMemo, String updated);
  addToDo(DayRecord dayRecord);
  updateToDoContent(DayRecord dayRecord, ToDo toDo, String updated);
}