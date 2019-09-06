
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemo.dart';
import 'package:tuple/tuple.dart';

class RecordState {
  final int year;
  final Tuple2<int, int> weeklySeparatedMonthAndNthWeek;
  final List<WeekMemo> weekMemos;
  final List<DayRecord> dayRecords;
  final bool isGoToTodayButtonShown;
  final bool isGoToTodayButtonShownLeft;

  const RecordState({
    this.year = 0,
    this.weeklySeparatedMonthAndNthWeek = const Tuple2(0, 0),
    this.weekMemos = const [],
    this.dayRecords = const [],
    this.isGoToTodayButtonShown = false,
    this.isGoToTodayButtonShownLeft = false,
  });

  String get yearText => '$year년';

  String get monthAndNthWeekText {
    final month = weeklySeparatedMonthAndNthWeek.item1;
    final nthWeek = weeklySeparatedMonthAndNthWeek.item2;
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
    Tuple2<int, int> weeklySeparatedMonthAndNthWeek,
    List<WeekMemo> weekMemos,
    List<DayRecord> days,
    bool isGoToTodayButtonShown,
    bool isGoToTodayButtonShownLeft,
  }) {
    return RecordState(
      year: year ?? this.year,
      weeklySeparatedMonthAndNthWeek: weeklySeparatedMonthAndNthWeek ?? this.weeklySeparatedMonthAndNthWeek,
      weekMemos: weekMemos ?? this.weekMemos,
      dayRecords: days ?? this.dayRecords,
      isGoToTodayButtonShown: isGoToTodayButtonShown ?? this.isGoToTodayButtonShown,
      isGoToTodayButtonShownLeft: isGoToTodayButtonShownLeft ?? this.isGoToTodayButtonShownLeft,
    );
  }

}