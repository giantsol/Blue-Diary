
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

class RecordRepositoryImpl implements RecordRepository {
  // 현재 주(week)에 해당하는 메모들 (3개로 고정된)
  final _weekMemoSet = BehaviorSubject<WeekMemoSet>.seeded(WeekMemoSet());

  // 현재 선택된 시간. 디폴트는 오늘.
  final _currentDateTime = BehaviorSubject<DateTime>.seeded(DateTime.now());

  // 페이징은 0, 1, 2 값 사이에서 infinite paging이 된다.
  var _currentDayRecordPageIndex = 0;

  @override
  Stream<WeekMemoSet> get weekMemoSet => _weekMemoSet.distinct();

  @override
  Stream<List<DayRecord>> get dayRecords => _currentDateTime.distinct()
    .map((DateTime currentDateTime) {
    // dayRecords의 크기는 항상 3으로 고정
    final dayRecords = List<DayRecord>(3);
    final oneDayDuration = Duration(days: 1);
    final currentPageIndex = _currentDayRecordPageIndex;

    dayRecords[currentPageIndex] = DayRecord(currentDateTime);

    final prevDateTime = currentDateTime.subtract(oneDayDuration);
    if (currentPageIndex == 0) {
      dayRecords[2] = DayRecord(prevDateTime);
    } else {
      dayRecords[currentPageIndex - 1] = DayRecord(prevDateTime);
    }

    final nextDateTime = currentDateTime.add(oneDayDuration);
    if (currentPageIndex == 2) {
      dayRecords[0] = DayRecord(nextDateTime);
    } else {
      dayRecords[currentPageIndex + 1] = DayRecord(nextDateTime);
    }

    return dayRecords;
  }).distinct();

  @override
  Stream<DateTime> get currentDateTime => _currentDateTime.distinct();

  RecordRepositoryImpl() {
    _weekMemoSet.onCancel = () => _weekMemoSet.close();
    _currentDateTime.onCancel = () => _currentDateTime.close();
  }

  @override
  void updateSingleWeekMemo(String updatedText, int index) {
    _weekMemoSet.add(_weekMemoSet.value.getModified(index, updatedText));
  }

  // DayRecord의 pageIndex가 변할 때 마다 현재 선택된 date (i.e. _currentDateTime)의 값을 업데이트한다.
  @override
  void updateDayRecordPageIndex(int updatedIndex) {
    final currentPageIndex = _currentDayRecordPageIndex;
    if (currentPageIndex == updatedIndex) {
      return;
    }
    _currentDayRecordPageIndex = updatedIndex;

    if ((currentPageIndex == 0 && updatedIndex == 1)
      || (currentPageIndex == 1 && updatedIndex == 2)
      || (currentPageIndex == 2 && updatedIndex == 0)) {
      _currentDateTime.add(_currentDateTime.value.add(Duration(days: 1)));
    } else {
      _currentDateTime.add(_currentDateTime.value.subtract(Duration(days: 1)));
    }
  }

}