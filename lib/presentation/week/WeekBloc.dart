
import 'package:rxdart/rxdart.dart';
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

  _initState({int weeksPageIndex}) async {
    final dateInWeek = _usecases.getCurrentDateInWeek();
    final currentWeekRecordPageIndex = weeksPageIndex ?? _state.value.weeksPageIndex;
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
      weeksPageIndex: currentWeekRecordPageIndex,
    ));
  }

  dispose() {
    _state.close();
  }
}