
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/usecase/RecordUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/record/RecordBlocDelegator.dart';
import 'package:todo_app/presentation/home/record/RecordStateV2.dart';

class RecordBlocV2 {
  RecordBlocDelegator delegator;

  final _state = BehaviorSubject<RecordStateV2>.seeded(RecordStateV2());
  RecordStateV2 getInitialState() => _state.value;
  Stream<RecordStateV2> observeState() => _state.distinct();

  final RecordUsecases _usecases = dependencies.recordUsecases;

  RecordBlocV2({this.delegator}) {
    _initState();
  }

  _initState({int weekRecordPageIndex}) async {
    final dateInWeek = _usecases.getCurrentDateInWeek();
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

  dispose() {
    _state.close();
  }
}