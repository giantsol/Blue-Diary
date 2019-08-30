
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

class RecordUsecases {
  final RecordRepository recordRepository;

  Stream<WeekMemoSet> get weekMemoSet => recordRepository.weekMemoSet;

  Stream<List<DayRecord>> get days => recordRepository.days;

  Stream<int> get currentYear => recordRepository.currentDateTime.map((dateTime) => dateTime.year);

  Stream<int> get currentMonth => recordRepository.currentDateTime.map((dateTime) => dateTime.month);

  Stream<int> get currentNthWeek => recordRepository.currentDateTime.map((dateTime) {
    final day = dateTime.day;
    final currentMonthFirstDate = DateTime.utc(dateTime.year, dateTime.month);
    int currentMonthFirstDateWeekDay = currentMonthFirstDate.weekday;

    if (day <= DateTime.sunday - currentMonthFirstDateWeekDay + 1) {
      return 1;
    } else {
      final adaptedDay = day - (DateTime.sunday - currentMonthFirstDateWeekDay + 2);
      return adaptedDay ~/ 7 + 1;
    }
  });

  const RecordUsecases(this.recordRepository);

  void updateSingleWeekMemo(String updatedText, int index) {
    recordRepository.updateSingleWeekMemo(updatedText, index);
  }

  void updateDayRecords(int focusedIndex) {
    recordRepository.updateDayRecords(focusedIndex);
  }
}