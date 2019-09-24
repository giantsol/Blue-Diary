
class DateInWeek {

  // todo: change naming to displayYear, displayMonth etc...
  final int year;
  final int month;
  final int nthWeek;
  final List<DateTime> datesInWeek;

  String get monthAndNthWeekText {
    final month = this.month;
    final nthWeek = this.nthWeek;
    switch (nthWeek) {
      case 0:
        return '$month월 첫째주';
      case 1:
        return '$month월 둘째주';
      case 2:
        return '$month월 셋째주';
      case 3:
        return '$month월 넷째주';
      case 4:
        return '$month월 다섯째주';
      default:
        throw Exception('invalid nthWeek value: $nthWeek');
    }
  }

  const DateInWeek({
    this.year = 0,
    this.month = 0,
    this.nthWeek = 0,
    this.datesInWeek = const [],
  });

  static DateInWeek fromDate(DateTime dateTime) {
    final day = dateTime.day;
    final weekday = dateTime.weekday;
    if (day - (weekday - DateTime.monday) <= 0) {
      return fromDate(dateTime.subtract(Duration(days: weekday - DateTime.monday)));
    } else {
      final nthWeek = (day - (weekday - DateTime.monday + 1)) ~/ 7;
      final List<DateTime> datesInWeek = [];
      final mondayOfWeek = dateTime.subtract(Duration(days: dateTime.weekday - DateTime.monday));
      for (int i = 0; i < 7; i++) {
        datesInWeek.add(mondayOfWeek.add(Duration(days: i)));
      }
      return DateInWeek(
        year: dateTime.year,
        month: dateTime.month,
        nthWeek: nthWeek,
        datesInWeek: datesInWeek,
      );
    }
  }

}