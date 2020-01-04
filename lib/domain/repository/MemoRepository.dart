
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';

abstract class MemoRepository {
  Future<List<CheckPoint>> getCheckPoints(DateTime date);
  Future<DayMemo> getDayMemo(DateTime date);
  Future<void> setDayMemo(DayMemo dayMemo);
  Future<void> setCheckPoint(CheckPoint checkPoint);
}