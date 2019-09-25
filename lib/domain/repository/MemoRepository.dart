
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';

abstract class MemoRepository {
  void setWeekMemo(WeekMemo weekMemo);
  Future<List<WeekMemo>> getWeekMemos(DateTime dateTime);
  Future<List<CheckPoint>> getCheckPoints(DateTime date);
  Future<DayMemo> getDayMemo(DateTime date);
  void setDayMemo(DayMemo dayMemo);
  void setCheckPoint(CheckPoint checkPoint);
}