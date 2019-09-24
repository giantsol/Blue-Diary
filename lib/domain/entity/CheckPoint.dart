
import 'package:todo_app/domain/entity/DateInWeek.dart';

class CheckPoint {

  static String dateToDateString(DateTime dateTime) {
    final dateInWeek = DateInWeek.fromDate(dateTime);
    return '${dateInWeek.year}-${dateInWeek.month}-${dateInWeek.nthWeek}';
  }

  final int index;
  final String text;
  final String hintText;

  const CheckPoint({
    this.index,
    this.text,
    this.hintText
  });

  CheckPoint buildNew({
    int index,
    String text,
    String hintText,
  }) {
    return CheckPoint(
      index: index ?? this.index,
      text: text ?? this.text,
      hintText: hintText ?? this.hintText,
    );
  }
}