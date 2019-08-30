
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