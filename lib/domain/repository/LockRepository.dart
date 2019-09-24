
abstract class LockRepository {
  Future<bool> getIsCheckPointsLocked(DateTime date);
  Future<bool> getIsDayRecordLocked(DateTime date);
}