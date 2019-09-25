
import 'package:todo_app/domain/entity/WeekRecord.dart';

enum ViewState {
  WHOLE_LOADING,
  NORMAL,
}

class WeekState {
  // todo: declared viewState, but not using it anywhere yet
  final ViewState viewState;
  final String year;
  final String monthAndWeek;
  final List<WeekRecord> weekRecords;
  final int weeksPageIndex;

  const WeekState({
    this.viewState = ViewState.WHOLE_LOADING,
    this.year = '',
    this.monthAndWeek = '',
    this.weekRecords = const [],
    this.weeksPageIndex = 0,
  });

  WeekState buildNew({
    ViewState viewState,
    String year,
    String monthAndWeek,
    List<WeekRecord> weekRecords,
    int weeksPageIndex,
  }) {
    return WeekState(
      viewState: viewState ?? this.viewState,
      year: year ?? this.year,
      monthAndWeek: monthAndWeek ?? this.monthAndWeek,
      weekRecords: weekRecords ?? this.weekRecords,
      weeksPageIndex: weeksPageIndex ?? this.weeksPageIndex,
    );
  }
}