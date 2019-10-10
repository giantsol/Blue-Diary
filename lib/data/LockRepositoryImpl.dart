
import 'package:todo_app/data/datasource/LockDataSource.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/repository/LockRepository.dart';

class LockRepositoryImpl implements LockRepository {
  final LockDataSource _dataSource;

  const LockRepositoryImpl(this._dataSource);

  @override
  Future<bool> getIsCheckPointsLocked(DateTime date, bool defaultValue) async {
    return await _dataSource.getIsCheckPointsLocked(date, defaultValue);
  }

  @override
  Future<bool> getIsDayRecordLocked(DateTime date, bool defaultValue) async {
    return await _dataSource.getIsDayRecordLocked(date, defaultValue);
  }

  @override
  void setIsCheckPointsLocked(DateInWeek dateInWeek, bool value) {
    _dataSource.setIsCheckPointsLocked(dateInWeek, value);
  }

  @override
  void setIsDayRecordLocked(DateTime date, bool value) {
    _dataSource.setIsDayRecordLocked(date, value);
  }

}