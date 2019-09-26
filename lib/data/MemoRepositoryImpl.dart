
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';

class MemoRepositoryImpl implements MemoRepository {
  final AppDatabase _db;

  const MemoRepositoryImpl(this._db);

  @override
  Future<List<CheckPoint>> getCheckPoints(DateTime date) async {
    return await _db.getCheckPoints(date);
  }

  @override
  Future<DayMemo> getDayMemo(DateTime date) async {
    return await _db.getDayMemo(date);
  }

  @override
  void setDayMemo(DayMemo dayMemo) {
    _db.setDayMemo(dayMemo);
  }

  @override
  void setCheckPoint(CheckPoint checkPoint) {
    _db.setCheckPoint(checkPoint);
  }

}