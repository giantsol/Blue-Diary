
class DateInNthWeek {

  final int year;
  final int month;
  final int nthWeek;

  const DateInNthWeek({this.year = 0, this.month = 0, this.nthWeek = 0});

  static DateInNthWeek fromDateTime(DateTime dateTime) {
    final day = dateTime.day;
    final weekday = dateTime.weekday;
    if (day - (weekday - DateTime.monday) <= 0) {
      return fromDateTime(dateTime.subtract(Duration(days: weekday - DateTime.monday)));
    } else {
      final temp = day - (weekday - DateTime.monday + 1);
      return DateInNthWeek(
        year: dateTime.year,
        month: dateTime.month,
        nthWeek: temp ~/ 7
      );
    }
  }

}