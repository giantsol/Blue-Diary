
import 'package:todo_app/domain/entity/WeekRecord.dart';

enum WeekViewState {
  WHOLE_LOADING,
  NORMAL,
}

class WeekState {
  // todo: declared viewState, but not using it anywhere yet
  final WeekViewState viewState;
  final int year;
  final int month;
  final int nthWeek;
  final List<WeekRecord> weekRecords;
  final int weekRecordPageIndex;

  const WeekState({
    this.viewState = WeekViewState.WHOLE_LOADING,
    this.year = 0,
    this.month = 0,
    this.nthWeek = 0,
    this.weekRecords = const [],
    this.weekRecordPageIndex = 0,
  });

  WeekState buildNew({
    WeekViewState viewState,
    int year,
    int month,
    int nthWeek,
    List<WeekRecord> weekRecords,
    int weekRecordPageIndex,
  }) {
    return WeekState(
      viewState: viewState ?? this.viewState,
      year: year ?? this.year,
      month: month ?? this.month,
      nthWeek: nthWeek ?? this.nthWeek,
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