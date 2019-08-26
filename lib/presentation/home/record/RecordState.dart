
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';

class RecordState {
  final int year;
  final int month;
  final int nthWeek;
  final WeekMemoSet weekMemoSet;
  final List<DayRecord> dayRecords;

  const RecordState({
    this.year = 0,
    this.month = 0,
    this.nthWeek = 0,
    this.weekMemoSet = const WeekMemoSet(),
    this.dayRecords = const [],
  });

  String get yearText => '$year년';

  String get monthAndNthWeekText {
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
    int year,
    int month,
    int nthWeek,
    WeekMemoSet weekMemoSet,
    List<DayRecord> days,
  }) {
    return RecordState(
      year: year ?? this.year,
      month: month ?? this.month,
      nthWeek: nthWeek ?? this.nthWeek,
      weekMemoSet: weekMemoSet ?? this.weekMemoSet,
      dayRecords: days ?? this.dayRecords,
    );
  }

}