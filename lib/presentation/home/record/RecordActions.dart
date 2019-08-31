
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';

abstract class RecordAction { }

class UpdateSingleWeekMemo implements RecordAction {
  final String updatedText;
  final int index;

  const UpdateSingleWeekMemo(this.updatedText, this.index);
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