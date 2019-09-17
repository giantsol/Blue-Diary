class DayMemo {

  static String dateTimeToDateString(DateTime dateTime) => '${dateTime.year}-${dateTime.month}-${dateTime.day}';

  final DateTime dateTime;
  final String content;

  String get key => dateTimeToDateString(dateTime);

  const DayMemo(this.dateTime, this.content);

  DayMemo buildNew({
    DateTime dateTime,
    String content,
  }) {
    return DayMemo(
      dateTime ?? this.dateTime,
      content ?? this.content,
    );
  }

  Map<String, dynamic> toDatabaseFormat() {
    return {
      'date_string': dateTimeToDateString(dateTime),
      'content': content,
    };
  }

}