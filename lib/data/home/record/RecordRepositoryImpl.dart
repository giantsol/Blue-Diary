
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/ToDo.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemo.dart';

class RecordRepositoryImpl implements RecordRepository {
  final AppDatabase _database;

  // 현재 선택된 시간. 디폴트는 오늘.
  final _currentDateTime = BehaviorSubject<DateTime>.seeded(DateTime.now());
  @override
  Stream<DateTime> get currentDateTime => _currentDateTime.distinct();

  // 현재 주(week)에 해당하는 메모들 (3개로 고정된)
  final _weekMemos = BehaviorSubject<List<WeekMemo>>.seeded([]);
  @override
  Stream<List<WeekMemo>> get weekMemos => _weekMemos.distinct();

  final _dayRecords = BehaviorSubject<List<DayRecord>>.seeded([]);
  @override
  Stream<List<DayRecord>> get dayRecords => _dayRecords.distinct();

  // 페이징은 0, 1, 2 값 사이에서 infinite paging이 된다.
  var _currentDayRecordPageIndex = 0;

  RecordRepositoryImpl(this._database) {
    _currentDateTime.distinct().listen((d) {
      _loadDayRecords();
      _loadWeekMemos();
    });
  }

  _loadDayRecords() async {
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

  _loadWeekMemos() async {
    // todo: week이 바뀔때만 로드하도록. 지금은 페이징 넘길 때 마다 새로 로드하니까
    _weekMemos.add(await _database.loadWeekMemos(_currentDateTime.value));
  }

  @override
  updateSingleWeekMemo(WeekMemo weekMemo, String updated) {
    final List<WeekMemo> weekMemos = List.of(_weekMemos.value);
    final updatedWeekMemo = weekMemo.getModified(content: updated);
    final changedIndex = weekMemos.indexWhere((item) => item.key == updatedWeekMemo.key);
    if (changedIndex >= 0) {
      weekMemos[changedIndex] = updatedWeekMemo;
      _weekMemos.add(weekMemos);
      _database.saveWeekMemo(updatedWeekMemo);
    }
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
    final List<DayRecord> dayRecords = List.of(_dayRecords.value);
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

  @override
  addToDo(DayRecord dayRecord) {
    final List<DayRecord> dayRecords = List.of(_dayRecords.value);
    final changedIndex = dayRecords.indexWhere((item) => item.title == dayRecord.title);
    if (changedIndex >= 0) {
      final List<ToDo> toDos = List.of(dayRecord.todos);
      toDos.add(ToDo(dayRecord.dateTime, toDos.length));
      dayRecords[changedIndex] = dayRecords[changedIndex].getModified(todos: toDos);
      _dayRecords.add(dayRecords);
      // 단순히 add만 했을 때는 DB에 넣지 않는다.
      // 실제 content를 작성하기 시작하면 DB에 넣는다.
    }
  }

  @override
  updateToDoContent(DayRecord dayRecord, ToDo toDo, String updated) {
    final List<DayRecord> dayRecords = List.of(_dayRecords.value);
    final changedIndex = dayRecords.indexWhere((item) => item.title == dayRecord.title);
    if (changedIndex >= 0) {
      final List<ToDo> toDos = List.of(dayRecord.todos);
      final changedToDoIndex = toDos.indexWhere((item) => item.key == toDo.key);
      if (changedToDoIndex >= 0) {
        final updatedToDo = toDo.getModified(content: updated);
        toDos[changedToDoIndex] = updatedToDo;
        dayRecords[changedIndex] = dayRecord.getModified(todos: toDos);
        _dayRecords.add(dayRecords);
        // todo: 썼다가 다 지워도 DB에 남는 문제
        _database.saveToDo(updatedToDo);
      }
    }
  }
}