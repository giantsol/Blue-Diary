
class DayRecord {
  final int date;
  final List<String> todos;
  final String memo;

  const DayRecord(this.date, {
    this.todos = const [],
    this.memo = '',
  });

  @override
  String toString() {
    return 'Day$date';
  }
}