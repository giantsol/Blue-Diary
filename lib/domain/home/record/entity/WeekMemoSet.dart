
class WeekMemoSet {

  final List<String> memos;

  const WeekMemoSet({
    this.memos = const ['', '', ''],
  });

  WeekMemoSet getModified(int index, String memo) {
    final copy = List.of(memos);
    copy[index] = memo;
    return WeekMemoSet(memos: copy);
  }

}