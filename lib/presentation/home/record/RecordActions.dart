
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/ToDo.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemo.dart';

abstract class RecordAction { }

class UpdateSingleWeekMemo implements RecordAction {
  final WeekMemo weekMemo;
  final String updated;

  const UpdateSingleWeekMemo(this.weekMemo, this.updated);
}

class UpdateDayRecordPageIndex implements RecordAction {
  final int updatedIndex;

  const UpdateDayRecordPageIndex(this.updatedIndex);
}

class NavigateToCalendarPage implements RecordAction { }

class UpdateDayMemo implements RecordAction {
  final DayMemo dayMemo;
  final String updated;

  const UpdateDayMemo(this.dayMemo, this.updated);
}

class AddToDo implements RecordAction {
  final DayRecord dayRecord;

  const AddToDo(this.dayRecord);
}

class UpdateToDoContent implements RecordAction {
  final DayRecord dayRecord;
  final ToDo toDo;
  final String updated;

  const UpdateToDoContent(this.dayRecord, this.toDo, this.updated);
}

class UpdateToDoDone implements RecordAction {
  final DayRecord dayRecord;
  final ToDo toDo;

  const UpdateToDoDone(this.dayRecord, this.toDo);
}