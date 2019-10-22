
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';

class DayRecord {
  final List<ToDoRecord> toDoRecords;
  final DayMemo dayMemo;
  final bool isToday;

  const DayRecord({
    this.toDoRecords = const [],
    this.dayMemo = const DayMemo(),
    this.isToday = false,
  });

  DayRecord buildNew({
    List<ToDoRecord> toDoRecords,
    DayMemo dayMemo,
    bool isToday,
  }) {
    return DayRecord(
      toDoRecords: toDoRecords ?? this.toDoRecords,
      dayMemo: dayMemo ?? this.dayMemo,
      isToday: isToday ?? this.isToday,
    );
  }

  DayRecord buildNewDayMemoUpdated(DayMemo updated) {
    if (dayMemo.key == updated.key) {
      return buildNew(dayMemo: updated);
    } else {
      return this;
    }
  }
}