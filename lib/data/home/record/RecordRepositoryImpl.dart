
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemoSet.dart';

class RecordRepositoryImpl implements RecordRepository {
  final AppDatabase _database;

  // 현재 선택된 시간. 디폴트는 오늘.
  final _currentDateTime = BehaviorSubject<DateTime>.seeded(DateTime.now());
  @override
  Stream<DateTime> get currentDateTime => _currentDateTime.distinct();

  // 현재 주(week)에 해당하는 메모들 (3개로 고정된)
  final _weekMemoSet = BehaviorSubject<WeekMemoSet>.seeded(WeekMemoSet());
  @override
  Stream<WeekMemoSet> get weekMemoSet => _weekMemoSet.distinct();

  final _dayRecords = BehaviorSubject<List<DayRecord>>.seeded([]);
  @override
  Stream<List<DayRecord>> get dayRecords => _dayRecords.distinct();

  // 페이징은 0, 1, 2 값 사이에서 infinite paging이 된다.
  var _currentDayRecordPageIndex = 0;

  RecordRepositoryImpl(this._database) {
    _currentDateTime.distinct().listen((d) => _updateDayRecords());
  }

  _updateDayRecords() async {
    // dayRecords의 크기는 항상 3으로 고정
    final dayRecords = List<DayRecord>(3);
    final currentDateTime = _currentDateTime.value;
    final oneDay = Duration(days: 1);
    final currentDayRecord = await _database.loadDayRecord(currentDateTime);
    final prevDayRecord = await _database.loadDayRecord(currentDateTime.subtract(oneDay));
    final nextDayRecord = await _database.loadDayRecord(currentDateTime.add(oneDay));
    final currentPageIndex = _currentDayRecordPageIndex;

    dayRecords[currentPageIndex] = currentDayRecord;

    if (currentPageIndex == 0) {
      dayRecords[2] = prevDayRecord;
    } else {
      dayRecords[currentPageIndex - 1] = prevDayRecord;
    }

    if (currentPageIndex == 2) {
      dayRecords[0] = nextDayRecord;
    } else {
      dayRecords[currentPageIndex + 1] = nextDayRecord;
    }

    _dayRecords.add(dayRecords);
  }

  @override
  updateSingleWeekMemo(String updatedText, int index) {
    _weekMemoSet.add(_weekMemoSet.value.getModified(index, updatedText));
  }

  // DayRecord의 pageIndex가 변할 때 마다 현재 선택된 date (i.e. _currentDateTime)의 값을 업데이트한다.
  @override
  updateDayRecordPageIndex(int updatedIndex) {
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

  @override
  updateDayMemo(DayMemo dayMemo, String updated) {
    final List<DayRecord> dayRecords = _dayRecords.value;
    final updatedDayMemo = dayMemo.getModified(content: updated);
    final changedIndex = dayRecords.indexWhere((item) => item.memo.key == dayMemo.key);
    if (changedIndex >= 0) {
      // 캐싱된 DayRecord 값을 업데이트해주면서 백그라운드에서 DB도 업데이트한다.
      // 완전히 data transparent하게 하려면 DB를 업데이트하고 다시 쿼리날려서 받아와야겠지만
      // 매번 타이핑 할때마다 그러면 속도가 우려되기 때문에..
      // 혹여 어떠한 이유로 DB 업데이트는 안되고 캐시만 업데이트 되었으면
      // 페이지를 나갔다 들어왔을 때 DB에 남아있는 값으로 업데이트 될 것이다.
      dayRecords[changedIndex] = dayRecords[changedIndex].getModified(memo: updatedDayMemo);
      _dayRecords.add(dayRecords);
      _database.saveDayMemo(updatedDayMemo);
    }
  }

}