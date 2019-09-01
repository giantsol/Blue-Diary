
class Utils {

  static int getNthWeek(DateTime dateTime) {
    final day = dateTime.day;
    final currentMonthFirstDate = DateTime.utc(dateTime.year, dateTime.month);
    int currentMonthFirstDateWeekDay = currentMonthFirstDate.weekday;

    if (day <= DateTime.sunday - currentMonthFirstDateWeekDay + 1) {
      return 0;
    } else {
      final adaptedDay = day -
        (DateTime.sunday - currentMonthFirstDateWeekDay + 2);
      return adaptedDay ~/ 7 + 1;
    }
  }

}