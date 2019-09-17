
import 'package:todo_app/domain/entity/DateInNthWeek.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';

class RecordState {
  final DateTime today;
  final int dayRecordPageIndex;
  final DateInNthWeek dateInNthWeek;
  final List<WeekMemo> weekMemos;
  final DayRecord currentDayRecord;
  final DayRecord prevDayRecord;
  final DayRecord nextDayRecord;

  const RecordState({
    this.today,
    this.dayRecordPageIndex = 0,
    this.dateInNthWeek = const DateInNthWeek(),
    this.weekMemos = const [],
    this.currentDayRecord,
    this.prevDayRecord,
    this.nextDayRecord,
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

  GoToTodayButtonVisibility get goToTodayButtonVisibility {
    if (today == null || prevDayRecord == null || currentDayRecord == null || nextDayRecord == null) {
      return GoToTodayButtonVisibility.GONE;
    }

    if (prevDayRecord.isToday || today.difference(currentDayRecord.dateTime).inDays < 0) {
      return GoToTodayButtonVisibility.LEFT;
    } else if (nextDayRecord.isToday || today.difference(currentDayRecord.dateTime).inDays > 0) {
      return GoToTodayButtonVisibility.RIGHT;
    } else {
      return GoToTodayButtonVisibility.GONE;
    }
  }

  List<DayRecord> get dayRecords {
    if (dayRecordPageIndex == 0) {
      return [currentDayRecord, nextDayRecord, prevDayRecord];
    } else if (dayRecordPageIndex == 1) {
      return [prevDayRecord, currentDayRecord, nextDayRecord];
    } else {
      return [nextDayRecord, prevDayRecord, currentDayRecord];
    }
  }

  RecordState buildNew({
    DateTime today,
    int dayRecordPageIndex,
    DateInNthWeek dateInNthWeek,
    List<WeekMemo> weekMemos,
    DayRecord currentDayRecord,
    DayRecord prevDayRecord,
    DayRecord nextDayRecord,
  }) {
    return RecordState(
      today: today ?? this.today,
      dayRecordPageIndex: dayRecordPageIndex ?? this.dayRecordPageIndex,
      dateInNthWeek: dateInNthWeek ?? this.dateInNthWeek,
      weekMemos: weekMemos ?? this.weekMemos,
      currentDayRecord: currentDayRecord ?? this.currentDayRecord,
      prevDayRecord: prevDayRecord ?? this.prevDayRecord,
      nextDayRecord: nextDayRecord ?? this.nextDayRecord,
    );
  }

  RecordState buildNewDayRecordUpdated(DayRecord dayRecord) {
    if (currentDayRecord?.key == dayRecord.key) {
      return buildNew(currentDayRecord: dayRecord);
    } else if (prevDayRecord?.key == dayRecord.key) {
      return buildNew(prevDayRecord: dayRecord);
    } else if (nextDayRecord?.key == dayRecord.key) {
      return buildNew(nextDayRecord: dayRecord);
    }

    return this;
  }

  RecordState buildNewWeekMemoUpdated(WeekMemo weekMemo) {
    final index = weekMemos.indexWhere((it) => it.key == weekMemo.key);
    if (index >= 0) {
      final newWeekMemos = List.of(weekMemos);
      newWeekMemos[index] = weekMemo;
      return buildNew(weekMemos: newWeekMemos);
    }
    return this;
  }

}

enum GoToTodayButtonVisibility {
  GONE,
  LEFT,
  RIGHT,
}