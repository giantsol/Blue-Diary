
import 'package:todo_app/domain/entity/DateInWeek.dart';

abstract class LockRepository {
  Future<bool> getIsCheckPointsLocked(DateTime date, bool defaultValue);
  Future<bool> getIsDayRecordLocked(DateTime date, bool defaultValue);
  void setIsCheckPointsLocked(DateInWeek dateInWeek, bool value);
  void setIsDayRecordLocked(DateTime date, bool value);
}