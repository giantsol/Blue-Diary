
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

abstract class RecordRepository {
  Stream<WeekMemoSet> get weekMemoSet;
  Stream<List<DayRecord>> get dayRecords;
  Stream<DateTime> get currentDateTime;

  void updateSingleWeekMemo(String updatedText, int index);
  void updateDayRecordPageIndex(int updatedIndex);
}