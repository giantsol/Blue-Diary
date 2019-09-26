
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';

abstract class MemoRepository {
  Future<List<CheckPoint>> getCheckPoints(DateTime date);
  Future<DayMemo> getDayMemo(DateTime date);
  void setDayMemo(DayMemo dayMemo);
  void setCheckPoint(CheckPoint checkPoint);
}