
import 'package:todo_app/domain/entity/DateInWeek.dart';

abstract class LockDataSource {
  Future<bool> getIsCheckPointsLocked(DateTime date, bool defaultValue);
  void setIsCheckPointsLocked(DateInWeek dateInWeek, bool value);
  Future<bool> getIsDayRecordLocked(DateTime date, bool defaultValue);
  void setIsDayRecordLocked(DateTime date, bool value);
}