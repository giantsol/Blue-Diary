
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

class RecordUsecases {
  final RecordRepository _recordRepository;

  Stream<WeekMemoSet> get weekMemoSet => _recordRepository.weekMemoSet;

  Stream<List<DayRecord>> get dayRecords => _recordRepository.dayRecords;

  Stream<int> get currentYear => _recordRepository.currentDateTime.map((dateTime) => dateTime.year);

  Stream<int> get currentMonth => _recordRepository.currentDateTime.map((dateTime) => dateTime.month);

  Stream<int> get currentNthWeek => _recordRepository.currentDateTime.map((dateTime) {
    final day = dateTime.day;
    final currentMonthFirstDate = DateTime.utc(dateTime.year, dateTime.month);
    int currentMonthFirstDateWeekDay = currentMonthFirstDate.weekday;

    if (day <= DateTime.sunday - currentMonthFirstDateWeekDay + 1) {
      return 0;
    } else {
      final adaptedDay = day - (DateTime.sunday - currentMonthFirstDateWeekDay + 2);
      return adaptedDay ~/ 7 + 1;
    }
  });

  const RecordUsecases(this._recordRepository);

  void updateSingleWeekMemo(String updatedText, int index) {
    _recordRepository.updateSingleWeekMemo(updatedText, index);
  }

  void updateDayRecordPageIndex(int updatedIndex) {
    _recordRepository.updateDayRecordPageIndex(updatedIndex);
  }
}