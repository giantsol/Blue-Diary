
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

class RecordRepositoryImpl implements RecordRepository {
  final _weekMemoSet = BehaviorSubject<WeekMemoSet>.seeded(WeekMemoSet());
  final _currentDateTime = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _currentDayRecordPageIndex = BehaviorSubject<int>.seeded(0);

  @override
  Stream<WeekMemoSet> get weekMemoSet => _weekMemoSet.distinct();

  @override
  Stream<List<DayRecord>> get dayRecords => Observable.combineLatest2(_currentDateTime, _currentDayRecordPageIndex,
    (DateTime currentDateTime, int currentDayRecordPageIndex) {
      // dayRecords의 크기는 항상 3으로 고정
      final dayRecords = List<DayRecord>(3);
      final oneDayDuration = Duration(days: 1);
      dayRecords[currentDayRecordPageIndex] = DayRecord(currentDateTime);
      if (currentDayRecordPageIndex == 0) {
        dayRecords[2] = DayRecord(currentDateTime.subtract(oneDayDuration));
      } else {
        dayRecords[currentDayRecordPageIndex - 1] = DayRecord(currentDateTime.subtract(oneDayDuration));
      }
      if (currentDayRecordPageIndex == 2) {
        dayRecords[0] = DayRecord(currentDateTime.add(oneDayDuration));
      } else {
        dayRecords[currentDayRecordPageIndex + 1] = DayRecord(currentDateTime.add(oneDayDuration));
      }
      return dayRecords;
    }).distinct();

  @override
  Stream<DateTime> get currentDateTime => _currentDateTime.distinct();

  RecordRepositoryImpl() {
    _weekMemoSet.onCancel = () => _weekMemoSet.close();
    _currentDateTime.onCancel = () => _currentDateTime.close();
    _currentDayRecordPageIndex.onCancel = () => _currentDayRecordPageIndex.close();
  }

  @override
  void updateSingleWeekMemo(String updatedText, int index) {
    _weekMemoSet.add(_weekMemoSet.value.getModified(index, updatedText));
  }

  @override
  void updateDayRecords(int focusedIndex) {
    final currentPageIndex = _currentDayRecordPageIndex.value;
    if (currentPageIndex == 0) {
      if (focusedIndex == 1) {
        _currentDateTime.add(_currentDateTime.value.add(Duration(days: 1)));
      } else {
        _currentDateTime.add(_currentDateTime.value.subtract(Duration(days: 1)));
      }
    } else if (currentPageIndex == 1) {
      if (focusedIndex == 2) {
        _currentDateTime.add(_currentDateTime.value.add(Duration(days: 1)));
      } else {
        _currentDateTime.add(_currentDateTime.value.subtract(Duration(days: 1)));
      }
    } else {
      if (focusedIndex == 0) {
        _currentDateTime.add(_currentDateTime.value.add(Duration(days: 1)));
      } else {
        _currentDateTime.add(_currentDateTime.value.subtract(Duration(days: 1)));
      }
    }
    _currentDayRecordPageIndex.add(focusedIndex);
  }

}