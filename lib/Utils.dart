
import 'package:tuple/tuple.dart';

class Utils {

  static Tuple2<int, int> getWeeklySeparatedMonthAndNthWeek(DateTime dateTime) {
    final day = dateTime.day;
    final weekday = dateTime.weekday;
    if (day - (weekday - DateTime.monday) <= 0) {
      return getWeeklySeparatedMonthAndNthWeek(dateTime.subtract(Duration(days: weekday - DateTime.monday)));
    } else {
      final temp = day - (weekday - DateTime.monday + 1);
      return Tuple2(dateTime.month, temp ~/ 7);
    }
  }

}