
class DateInWeek {
  static DateInWeek fromDate(DateTime dateTime) {
    final day = dateTime.day;
    final weekday = dateTime.weekday;
    if (day - (weekday - DateTime.monday) <= 0) {
      return fromDate(dateTime.subtract(Duration(days: weekday - DateTime.monday)));
    } else {
      return DateInWeek(
        year: dateTime.year,
        month: dateTime.month,
        nthWeek: (day - (weekday - DateTime.monday + 1)) ~/ 7,
      );
    }
  }

  final int year;
  final int month;
  final int nthWeek;

  const DateInWeek({
    this.year = 0,
    this.month = 0,
    this.nthWeek = 0,
  });
}