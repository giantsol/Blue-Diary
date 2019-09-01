
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
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