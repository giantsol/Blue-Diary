
import 'package:todo_app/data/datasource/MemoDataSource.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';

class MemoRepositoryImpl implements MemoRepository {
  final MemoDataSource _dataSource;

  const MemoRepositoryImpl(this._dataSource);

  @override
  Future<List<CheckPoint>> getCheckPoints(DateTime date) {
    return _dataSource.getCheckPoints(date);
  }

  @override
  Future<DayMemo> getDayMemo(DateTime date) {
    return _dataSource.getDayMemo(date);
  }

  @override
  void setDayMemo(DayMemo dayMemo) {
    _dataSource.setDayMemo(dayMemo);
  }

  @override
  void setCheckPoint(CheckPoint checkPoint) {
    _dataSource.setCheckPoint(checkPoint);
  }
}