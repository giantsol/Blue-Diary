
import 'package:todo_app/domain/entity/DateInWeek.dart';

abstract class LockRepository {
  Future<bool> getIsCheckPointsLocked(DateTime date);
  Future<bool> getIsDayRecordLocked(DateTime date);
  void setIsCheckPointsLocked(DateInWeek dateInWeek, bool value);
  void setIsDayRecordLocked(DateTime date, bool value);
}