
import 'package:todo_app/data/datasource/AppDatabase.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';

class MemoRepositoryImpl implements MemoRepository {
  final AppDatabase _database;

  const MemoRepositoryImpl(this._database);

  @override
  Future<List<CheckPoint>> getCheckPoints(DateTime date) {
    return _database.getCheckPoints(date);
  }

  @override
  Future<DayMemo> getDayMemo(DateTime date) {
    return _database.getDayMemo(date);
  }

  @override
  Future<void> setDayMemo(DayMemo dayMemo) {
    return _database.setDayMemo(dayMemo);
  }

  @override
  Future<void> setCheckPoint(CheckPoint checkPoint) {
    return _database.setCheckPoint(checkPoint);
  }
}