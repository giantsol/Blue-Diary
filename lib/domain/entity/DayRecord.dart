
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';

class DayRecord {
  final List<ToDoRecord> toDoRecords;
  final DayMemo dayMemo;
  final bool isLocked;

  const DayRecord({
    this.toDoRecords = const [],
    this.dayMemo = const DayMemo(),
    this.isLocked = false,
  });

  DayRecord buildNew({
    List<ToDoRecord> toDoRecords,
    DayMemo dayMemo,
    bool isLocked,
  }) {
    return DayRecord(
      toDoRecords: toDoRecords ?? this.toDoRecords,
      dayMemo: dayMemo ?? this.dayMemo,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}