
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';

abstract class RecordRepository {
  Stream<WeekMemoSet> get weekMemoSet;
  Stream<List<DayRecord>> get dayRecords;
  Stream<DateTime> get currentDateTime;

  updateSingleWeekMemo(String updatedText, int index);
  updateDayRecordPageIndex(int updatedIndex);
  updateDayMemo(DayMemo dayMemo, String updated);
}