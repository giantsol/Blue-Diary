
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/home/entity/DrawerItem.dart';
import 'package:todo_app/domain/home/HomeRepository.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordRepository.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemoSet.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';

class RecordUsecases {
  final RecordRepository _recordRepository;
  final HomeRepository _homeRepository;

  Stream<WeekMemoSet> get weekMemoSet => _recordRepository.weekMemoSet;

  Stream<List<DayRecord>> get dayRecords => _recordRepository.dayRecords;

  Stream<int> get currentYear => _recordRepository.currentDateTime.map((dateTime) => dateTime.year);

  Stream<int> get currentMonth => _recordRepository.currentDateTime.map((dateTime) => dateTime.month);

  Stream<int> get currentNthWeek => _recordRepository.currentDateTime.map(Utils.getNthWeek);

  const RecordUsecases(this._recordRepository, this._homeRepository);

  updateSingleWeekMemo(String updatedText, int index) {
    _recordRepository.updateSingleWeekMemo(updatedText, index);
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
}