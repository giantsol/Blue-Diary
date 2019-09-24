
import 'package:todo_app/domain/entity/WeekRecord.dart';

enum ViewState {
  WHOLE_LOADING,
  NORMAL,
}

class RecordStateV2 {
  // todo: declared viewState, but not using it anywhere yet
  final ViewState viewState;
  final String year;
  final String monthAndWeek;
  final List<WeekRecord> weekRecords;
  final int weekRecordPageIndex;

  const RecordStateV2({
    this.viewState = ViewState.WHOLE_LOADING,
    this.year = '',
    this.monthAndWeek = '',
    this.weekRecords = const [],
    this.weekRecordPageIndex = 0,
  });

  RecordStateV2 buildNew({
    ViewState viewState,
    String year,
    String monthAndWeek,
    List<WeekRecord> weekRecords,
    int weekRecordPageIndex,
  }) {
    return RecordStateV2(
      viewState: viewState ?? this.viewState,
      year: year ?? this.year,
      monthAndWeek: monthAndWeek ?? this.monthAndWeek,
      weekRecords: weekRecords ?? this.weekRecords,
      weekRecordPageIndex: weekRecordPageIndex ?? this.weekRecordPageIndex,
    );
  }
}