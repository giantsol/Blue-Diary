
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';

abstract class MemoRepository {

  saveWeekMemo(WeekMemo weekMemo);
  Future<List<WeekMemo>> getWeekMemos(DateTime dateTime);
  Future<DayMemo> getDayMemo(DateTime date);
  saveDayMemo(DayMemo dayMemo);

}