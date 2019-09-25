
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';

class Lock {
  static String createWhereQuery() => '${AppDatabase.COLUMN_KEY} = ?';

  static String createKeyForCheckPoints(DateInWeek dateInWeek) =>
    '${dateInWeek.year}-${dateInWeek.month}-${dateInWeek.nthWeek}-checkpoints';

  static String createKeyForDayRecord(DateTime date) =>
    '${date.year}-${date.month}-${date.day}-dayrecord';

  static List<dynamic> createWhereArgsForCheckPoints(DateInWeek dateInWeek) => [
    createKeyForCheckPoints(dateInWeek),
  ];

  static List<dynamic> createWhereArgsForDayRecord(DateTime date) => [
    createKeyForDayRecord(date),
  ];

  static Lock fromDatabase(Map<String, dynamic> map) {
    return Lock(
      key: map[AppDatabase.COLUMN_KEY] ?? '',
      isLocked: (map[AppDatabase.COLUMN_LOCKED] ?? 0) == 1,
    );
  }

  final String key;
  final bool isLocked;

  const Lock({
    this.key = '',
    this.isLocked = false,
  });

}