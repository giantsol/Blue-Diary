
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/presentation/week/WeekScreen.dart';

enum WeekViewState {
  WHOLE_LOADING,
  NORMAL,
}

class WeekState {
  final WeekViewState viewState;
  final int year;
  final int month;
  final int nthWeek;
  final Map<int, WeekRecord> pageIndexWeekRecordMap;
  final DateTime initialDate;
  final int initialWeekRecordPageIndex;
  final DateTime currentDate;
  final int currentWeekRecordPageIndex;

  final bool moveToTodayEvent;

  WeekRecord get currentWeekRecord => pageIndexWeekRecordMap[currentWeekRecordPageIndex];

  const WeekState({
    this.viewState = WeekViewState.WHOLE_LOADING,
    this.year = 0,
    this.month = 0,
    this.nthWeek = 0,
    this.pageIndexWeekRecordMap = const {},
    this.initialDate,
    this.initialWeekRecordPageIndex = WeekScreen.INITIAL_WEEK_PAGE,
    this.currentDate,
    this.currentWeekRecordPageIndex = WeekScreen.INITIAL_WEEK_PAGE,

    this.moveToTodayEvent = false,
  });

  WeekRecord getWeekRecordForPageIndex(int index) {
    return pageIndexWeekRecordMap[index];
  }

  WeekState buildNew({
    WeekViewState viewState,
    int year,
    int month,
    int nthWeek,
    WeekRecord currentWeekRecord,
    WeekRecord prevWeekRecord,
    WeekRecord nextWeekRecord,
    DateTime initialDate,
    int currentWeekRecordPageIndex,
    DateTime currentDate,

    bool moveToTodayEvent,
  }) {
    final prevMap = this.pageIndexWeekRecordMap;
    final currentPageIndex = currentWeekRecordPageIndex ?? this.currentWeekRecordPageIndex;
    final Map<int, WeekRecord> pageIndexWeekRecordMap = {
      currentPageIndex - 1: prevWeekRecord ?? prevMap[currentPageIndex - 1],
      currentPageIndex: currentWeekRecord ?? prevMap[currentPageIndex],
      currentPageIndex + 1: nextWeekRecord ?? prevMap[currentPageIndex + 1],
    };
    return WeekState(
      viewState: viewState ?? this.viewState,
      year: year ?? this.year,
      month: month ?? this.month,
      nthWeek: nthWeek ?? this.nthWeek,
      pageIndexWeekRecordMap: pageIndexWeekRecordMap,
      initialDate: initialDate ?? this.initialDate,
      currentWeekRecordPageIndex: currentWeekRecordPageIndex ?? this.currentWeekRecordPageIndex,
      currentDate: currentDate ?? this.currentDate,

      moveToTodayEvent: moveToTodayEvent ?? false,
    );
  }

  WeekState buildNewCheckPointUpdated(CheckPoint updated) {
    return buildNew(currentWeekRecord: currentWeekRecord.buildNewCheckPointUpdated(updated));
  }
}