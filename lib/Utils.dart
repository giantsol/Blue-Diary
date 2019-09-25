

class Utils {

  static bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  static List<DateTime> getDatesInWeek(DateTime date) {
    final List<DateTime> datesInWeek = [];
    final mondayOfWeek = date.subtract(Duration(days: date.weekday - DateTime.monday));
    for (int i = 0; i < 7; i++) {
      datesInWeek.add(mondayOfWeek.add(Duration(days: i)));
    }
    return datesInWeek;
  }

}