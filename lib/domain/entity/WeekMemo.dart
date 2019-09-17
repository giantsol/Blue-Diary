
import 'package:todo_app/domain/entity/DateInNthWeek.dart';

class WeekMemo {

  static String dateTimeToDateString(DateTime dateTime) {
    final dateInNthWeek = DateInNthWeek.fromDateTime(dateTime);
    return '${dateInNthWeek.year}-${dateInNthWeek.month}-${dateInNthWeek.nthWeek}';
  }

  final DateTime dateTime;
  final int index;
  final String content;

  String get key => '${dateTimeToDateString(dateTime)}-$index';

  const WeekMemo(this.dateTime, this.index, {
    this.content = '',
  });

  WeekMemo buildNew({
    DateTime dateTime,
    int index,
    String content,
  }) {
    return WeekMemo(
      dateTime ?? this.dateTime,
      index ?? this.index,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toDatabaseFormat() {
    return {
      'date_string': dateTimeToDateString(dateTime),
      'which': index,
      'content': content,
    };
  }

}