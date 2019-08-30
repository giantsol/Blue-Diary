
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

class RecordRepositoryImpl implements RecordRepository {
  final _weekMemoSet = BehaviorSubject<WeekMemoSet>.seeded(WeekMemoSet());
  final _days = BehaviorSubject<List<DayRecord>>.seeded([
    DayRecord(1, todos: ['hello', 'there', 'a', 'b', 'c', 'd', 'e', 'f']),
    DayRecord(2),
    DayRecord(0),
  ]);
  final _currentDateTime = BehaviorSubject<DateTime>.seeded(DateTime.now());

  @override
  Stream<WeekMemoSet> get weekMemoSet => _weekMemoSet.distinct();

  @override
  Stream<List<DayRecord>> get days => _days.distinct();

  @override
  Stream<DateTime> get currentDateTime => _currentDateTime.distinct();

  RecordRepositoryImpl() {
    _weekMemoSet.onCancel = () => _weekMemoSet.close();
    _days.onCancel = () => _days.close();
    _currentDateTime.onCancel = () => _currentDateTime.close();
  }

  @override
  void updateSingleWeekMemo(String updatedText, int index) {
    _weekMemoSet.add(_weekMemoSet.value.getModified(index, updatedText));
  }

  @override
  void updateDayRecords(int focusedIndex) {
    final selectedDate = _days.value[focusedIndex].date;
    final copy = List.of(_days.value);
    copy[focusedIndex] = DayRecord(selectedDate);
    if (focusedIndex == 0) {
      copy[2] = DayRecord(selectedDate - 1);
    } else {
      copy[focusedIndex - 1] = DayRecord(selectedDate - 1);
    }
    if (focusedIndex == 2) {
      copy[0] = DayRecord(selectedDate + 1);
    } else {
      copy[focusedIndex + 1] = DayRecord(selectedDate + 1);
    }
    _days.add(copy);
  }

}