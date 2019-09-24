
import 'package:todo_app/domain/entity/DateInWeek.dart';

class WeekMemo {

  static String dateTimeToDateString(DateTime dateTime) {
    final dateInWeek = DateInWeek.fromDate(dateTime);
    return '${dateInWeek.year}-${dateInWeek.month}-${dateInWeek.nthWeek}';
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