
import 'package:todo_app/domain/entity/DateInNthWeek.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';

class RecordState {
  final int dayRecordPageIndex;
  final DateInNthWeek dateInNthWeek;
  final List<WeekMemo> weekMemos;
  final DayRecord currentDayRecord;
  final DayRecord prevDayRecord;
  final DayRecord nextDayRecord;
  final GoToTodayButtonVisibility goToTodayButtonVisibility;

  const RecordState({
    this.dayRecordPageIndex = 0,
    this.dateInNthWeek = const DateInNthWeek(),
    this.weekMemos = const [],
    this.currentDayRecord,
    this.prevDayRecord,
    this.nextDayRecord,
    this.goToTodayButtonVisibility = GoToTodayButtonVisibility.GONE,
  });

  String get yearText => '${dateInNthWeek.year}';

  String get monthAndNthWeekText {
    final month = dateInNthWeek.month;
    final nthWeek = dateInNthWeek.nthWeek;
    switch (nthWeek) {
      case 0:
        return '$month월 첫째주';
      case 1:
        return '$month월 둘째주';
      case 2:
        return '$month월 셋째주';
      case 3:
        return '$month월 넷째주';
      case 4:
        return '$month월 다섯째주';
      default:
        throw Exception('invalid nthWeek value: $nthWeek');
    }
  }

  RecordState getModified({
    int dayRecordPageIndex,
    DateInNthWeek dateInNthWeek,
    List<WeekMemo> weekMemos,
    DayRecord currentDayRecord,
    DayRecord prevDayRecord,
    DayRecord nextDayRecord,
    GoToTodayButtonVisibility goToTodayButtonVisibility,
  }) {
    return RecordState(
      dayRecordPageIndex: dayRecordPageIndex ?? this.dayRecordPageIndex,
      dateInNthWeek: dateInNthWeek ?? this.dateInNthWeek,
      weekMemos: weekMemos ?? this.weekMemos,
      currentDayRecord: currentDayRecord ?? this.currentDayRecord,
      prevDayRecord: prevDayRecord ?? this.prevDayRecord,
      nextDayRecord: nextDayRecord ?? this.nextDayRecord,
      goToTodayButtonVisibility: goToTodayButtonVisibility ?? this.goToTodayButtonVisibility,
    );
  }

  RecordState getDayRecordModified(DayRecord dayRecord) {
    if (currentDayRecord?.key == dayRecord.key) {
      return getModified(currentDayRecord: dayRecord);
    } else if (prevDayRecord?.key == dayRecord.key) {
      return getModified(prevDayRecord: dayRecord);
    } else if (nextDayRecord?.key == dayRecord.key) {
      return getModified(nextDayRecord: dayRecord);
    }

    return this;
  }

}

enum GoToTodayButtonVisibility {
  GONE,
  LEFT,
  RIGHT,
}