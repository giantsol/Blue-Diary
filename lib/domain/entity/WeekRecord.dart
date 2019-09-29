
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';

class WeekRecord {
  final DateInWeek dateInWeek;
  final bool isCheckPointsLocked;
  final List<CheckPoint> checkPoints;
  final List<DayRecord> dayRecords;

  String get key => '${dateInWeek.year}-${dateInWeek.month}-${dateInWeek.nthWeek}';

  const WeekRecord({
    this.dateInWeek = const DateInWeek(),
    this.isCheckPointsLocked = false,
    this.checkPoints = const [],
    this.dayRecords = const [],
  });

  WeekRecord buildNew({
    bool isCheckPointsLocked,
    List<CheckPoint> checkPoints,
    List<DayRecord> dayRecords,
  }) {
    return WeekRecord(
      dateInWeek: this.dateInWeek,
      isCheckPointsLocked: isCheckPointsLocked ?? this.isCheckPointsLocked,
      checkPoints: checkPoints ?? this.checkPoints,
      dayRecords: dayRecords ?? this.dayRecords,
    );
  }

  WeekRecord buildNewCheckPointUpdated(CheckPoint updated) {
    final updatedCheckPoints = List.of(checkPoints);
    final updatedIndex = updatedCheckPoints.indexWhere((it) => it.key == updated.key);
    if (updatedIndex >= 0) {
      updatedCheckPoints[updatedIndex] = updated;
    }
    return buildNew(checkPoints: updatedCheckPoints);
  }

  WeekRecord buildNewDayRecordUpdated(DayRecord updated) {
    final updatedDayRecords = List.of(dayRecords);
    final updatedIndex = updatedDayRecords.indexWhere((it) => it.key == updated.key);
    if (updatedIndex >= 0) {
      updatedDayRecords[updatedIndex] = updated;
    }
    return buildNew(dayRecords: updatedDayRecords);
  }
}