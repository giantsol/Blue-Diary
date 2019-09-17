
class ToDo {

  static String dateTimeToDateString(DateTime dateTime) => '${dateTime.year}-${dateTime.month}-${dateTime.day}';

  final DateTime dateTime;
  final int index;
  final String content;
  final bool isDone;

  String get key => '${dateTimeToDateString(dateTime)}-$index';

  const ToDo(this.dateTime, this.index, {
    this.content = '',
    this.isDone = false,
  });

  ToDo buildNew({
    DateTime dateTime,
    int index,
    String content,
    bool isDone,
  }) {
    return ToDo(
      dateTime ?? this.dateTime,
      index ?? this.index,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toDatabaseFormat() {
    return {
      'date_string': dateTimeToDateString(dateTime),
      'which': index,
      'content': content,
      'done': isDone ? 1 : 0,
    };
  }

}