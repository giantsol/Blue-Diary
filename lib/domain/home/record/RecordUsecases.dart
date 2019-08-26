
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

class RecordUsecases {
  final RecordRepository recordRepository;

  Stream<WeekMemoSet> get weekMemoSet => recordRepository.weekMemoSet;

  Stream<List<DayRecord>> get days => recordRepository.days;

  const RecordUsecases(this.recordRepository);

  void updateSingleWeekMemo(String updatedText, int index) {
    recordRepository.updateSingleWeekMemo(updatedText, index);
  }

  void updateDayRecords(int focusedIndex) {
    recordRepository.updateDayRecords(focusedIndex);
  }
}