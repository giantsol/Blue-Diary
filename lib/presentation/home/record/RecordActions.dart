
abstract class RecordAction { }

class UpdateSingleWeekMemo implements RecordAction {
  final String updatedText;
  final int index;

  const UpdateSingleWeekMemo(this.updatedText, this.index);
}

class UpdateDayRecords implements RecordAction {
  final int focusedIndex;

  const UpdateDayRecords(this.focusedIndex);
}