
class DayRecord {
  final DateTime dateTime;
  final List<String> todos;
  final String memo;

  const DayRecord(this.dateTime, {
    this.todos = const [],
    this.memo = '',
  });

  @override
  String toString() {
    final day = dateTime.day;
    switch (dateTime.weekday) {
      case DateTime.monday:
        return '$day일 월';
      case DateTime.tuesday:
        return '$day일 화';
      case DateTime.wednesday:
        return '$day일 수';
      case DateTime.thursday:
        return '$day일 목';
      case DateTime.friday:
        return '$day일 금';
      case DateTime.saturday:
        return '$day일 토';
      default:
        return '$day일 일';
    }
  }
}