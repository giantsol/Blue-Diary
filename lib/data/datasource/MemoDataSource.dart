
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';

abstract class MemoDataSource {
  Future<List<CheckPoint>> getCheckPoints(DateTime date);
  void setCheckPoint(CheckPoint checkPoint);
  Future<DayMemo> getDayMemo(DateTime date);
  void setDayMemo(DayMemo dayMemo);
}