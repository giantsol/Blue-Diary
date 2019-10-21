
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';

class DayRecord {
  final List<ToDoRecord> toDoRecords;
  final DayMemo dayMemo;

  const DayRecord({
    this.toDoRecords = const [],
    this.dayMemo = const DayMemo(),
  });

  DayRecord buildNew({
    List<ToDoRecord> toDoRecords,
    DayMemo dayMemo,
  }) {
    return DayRecord(
      toDoRecords: toDoRecords ?? this.toDoRecords,
      dayMemo: dayMemo ?? this.dayMemo,
    );
  }
}