
import 'package:todo_app/domain/entity/WeekRecord.dart';

enum WeekViewState {
  WHOLE_LOADING,
  NORMAL,
}

class WeekState {
  // todo: declared viewState, but not using it anywhere yet
  final WeekViewState viewState;
  final String year;
  final String monthAndWeek;
  final List<WeekRecord> weekRecords;
  final int weekRecordPageIndex;

  const WeekState({
    this.viewState = WeekViewState.WHOLE_LOADING,
    this.year = '',
    this.monthAndWeek = '',
    this.weekRecords = const [],
    this.weekRecordPageIndex = 0,
  });

  WeekState buildNew({
    WeekViewState viewState,
    String year,
    String monthAndWeek,
    List<WeekRecord> weekRecords,
    int weekRecordPageIndex,
  }) {
    return WeekState(
      viewState: viewState ?? this.viewState,
      year: year ?? this.year,
      monthAndWeek: monthAndWeek ?? this.monthAndWeek,
      weekRecords: weekRecords ?? this.weekRecords,
      weekRecordPageIndex: weekRecordPageIndex ?? this.weekRecordPageIndex,
    );
  }

  WeekState buildNewWeekRecordUpdated(WeekRecord updated) {
    final newRecords = List.of(weekRecords);
    final updatedIndex = newRecords.indexWhere((it) => it.key == updated.key);
    if (updatedIndex >= 0) {
      newRecords[updatedIndex] = updated;
    }
    return buildNew(weekRecords: newRecords);
  }
}