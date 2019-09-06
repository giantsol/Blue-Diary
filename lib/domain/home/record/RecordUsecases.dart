
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/home/HomeRepository.dart';
import 'package:todo_app/domain/home/entity/DrawerItem.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/ToDo.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemo.dart';
import 'package:tuple/tuple.dart';

class RecordUsecases {
  final RecordRepository _recordRepository;
  final HomeRepository _homeRepository;

  Stream<List<WeekMemo>> get weekMemos => _recordRepository.weekMemos;

  Stream<List<DayRecord>> get dayRecords => _recordRepository.dayRecords;

  Stream<int> get currentYear => _recordRepository.currentDateTime.map((dateTime) => dateTime.year);

  Stream<Tuple2<int, int>> get currentWeeklySeparatedMonthAndNthWeek =>
  _recordRepository.currentDateTime.map(Utils.getWeeklySeparatedMonthAndNthWeek);

  const RecordUsecases(this._recordRepository, this._homeRepository);

  updateSingleWeekMemo(WeekMemo weekMemo, String updated) {
    _recordRepository.updateSingleWeekMemo(weekMemo, updated);
  }

  updateDayRecordPageIndex(int updatedIndex) {
    _recordRepository.updateDayRecordPageIndex(updatedIndex);
  }

  navigateToCalendarPage() {
    _homeRepository.selectDrawerChildScreenItem(DrawerChildScreenItem.KEY_CALENDAR);
  }

  updateDayMemo(DayMemo dayMemo, String updated) {
    _recordRepository.updateDayMemo(dayMemo, updated);
  }

  addToDo(DayRecord dayRecord) {
    _recordRepository.addToDo(dayRecord);
  }

  updateToDoContent(DayRecord dayRecord, ToDo toDo, String updated) {
    _recordRepository.updateToDoContent(dayRecord, toDo, updated);
  }

  updateToDoDone(DayRecord dayRecord, ToDo toDo) {
    _recordRepository.updateToDoDone(dayRecord, toDo);
  }
}