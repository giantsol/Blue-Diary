
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/usecase/WeekUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/week/WeekBlocDelegator.dart';
import 'package:todo_app/presentation/week/WeekState.dart';

class WeekBloc {
  WeekBlocDelegator delegator;

  final _state = BehaviorSubject<WeekState>.seeded(WeekState());
  WeekState getInitialState() => _state.value;
  Stream<WeekState> observeState() => _state.distinct();

  final WeekUsecases _usecases = dependencies.weekUsecases;

  WeekBloc({this.delegator}) {
    _initState();
  }

  Future<void> _initState({int weekRecordPageIndex}) async {
    final dateInWeek = DateInWeek.fromDate(_usecases.getCurrentDate());
    final currentWeekRecordPageIndex = weekRecordPageIndex ?? _state.value.weekRecordPageIndex;
    final currentWeekRecord = await _usecases.getCurrentWeekRecord();
    final prevWeekRecord = await _usecases.getPrevWeekRecord();
    final nextWeekRecord = await _usecases.getNextWeekRecord();
    var weekRecords;
    if (currentWeekRecordPageIndex == 0) {
      weekRecords = [currentWeekRecord, nextWeekRecord, prevWeekRecord];
    } else if (currentWeekRecordPageIndex == 1) {
      weekRecords = [prevWeekRecord, currentWeekRecord, nextWeekRecord];
    } else {
      weekRecords = [nextWeekRecord, prevWeekRecord, currentWeekRecord];
    }

    _state.add(_state.value.buildNew(
      viewState: ViewState.NORMAL,
      year: dateInWeek.year.toString(),
      monthAndWeek: dateInWeek.monthAndNthWeekText,
      weekRecords: weekRecords,
      weekRecordPageIndex: currentWeekRecordPageIndex,
    ));
  }

  void onWeekRecordPageChanged(int newIndex) {
    final curIndex = _state.value.weekRecordPageIndex;
    if ((curIndex == 0 && newIndex == 1)
      || (curIndex == 1 && newIndex == 2)
      || (curIndex == 2 && newIndex == 0)) {
      _usecases.setCurrentDateToNextWeek();
    } else {
      _usecases.setCurrentDateToPrevWeek();
    }
    _initState(weekRecordPageIndex: newIndex);
  }

  void onHeaderClicked() {
    _usecases.setCurrentDateToToday();
    _initState();
  }

  void onCheckPointsLockedIconClicked(WeekRecord weekRecord) {
    final updatedWeekRecord = weekRecord.buildNew(isCheckPointsLocked: false);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setCheckPointsLocked(weekRecord.dateInWeek, false);
  }

  void onCheckPointsUnlockedIconClicked(WeekRecord weekRecord) {
    final updatedWeekRecord = weekRecord.buildNew(isCheckPointsLocked: true);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setCheckPointsLocked(weekRecord.dateInWeek, true);
  }

  void onCheckPointTextChanged(WeekRecord weekRecord, CheckPoint checkPoint, String changed) {
    final updatedCheckPoint = checkPoint.buildNew(text: changed);
    final updatedWeekRecord = weekRecord.buildNewCheckPointUpdated(updatedCheckPoint);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setCheckPoint(checkPoint);
  }

  void onDayPreviewClicked(DayPreview dayPreview) {

  }

  void onDayPreviewLockedIconClicked(WeekRecord weekRecord, DayPreview dayPreview) {
    final updatedDayPreview = dayPreview.buildNew(isLocked: false);
    final updatedWeekRecord = weekRecord.buildNewDayPreviewUpdated(updatedDayPreview);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setDayRecordLocked(dayPreview.date, false);
  }

  void onDayPreviewUnlockedIconClicked(WeekRecord weekRecord, DayPreview dayPreview) {
    final updatedDayPreview = dayPreview.buildNew(isLocked: true);
    final updatedWeekRecord = weekRecord.buildNewDayPreviewUpdated(updatedDayPreview);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setDayRecordLocked(dayPreview.date, true);
  }

  void dispose() {
    _state.close();
  }
}