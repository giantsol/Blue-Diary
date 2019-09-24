
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';

class LockRepositoryImpl implements LockRepository {
  final AppDatabase _db;

  const LockRepositoryImpl(this._db);

  @override
  Future<bool> getIsCheckPointsLocked(DateTime date) async {
    return await _db.loadIsCheckPointsLocked(date);
  }

  @override
  Future<bool> getIsDayRecordLocked(DateTime date) async {
    return await _db.loadIsDayRecordLocked(date);
  }

}