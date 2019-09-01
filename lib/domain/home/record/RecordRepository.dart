
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemoSet.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';

abstract class RecordRepository {
  Stream<DateTime> get currentDateTime;
  Stream<WeekMemoSet> get weekMemoSet;
  Stream<List<DayRecord>> get dayRecords;

  updateSingleWeekMemo(String updatedText, int index);
  updateDayRecordPageIndex(int updatedIndex);
  updateDayMemo(DayMemo dayMemo, String updated);
}