
import 'package:todo_app/data/AppDatabase.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/WeekMemo.dart';
import 'package:todo_app/domain/repository/MemoRepository.dart';

class MemoRepositoryImpl implements MemoRepository {
  final AppDatabase _db;

  const MemoRepositoryImpl(this._db);

  @override
  saveWeekMemo(WeekMemo weekMemo) {
    _db.saveWeekMemo(weekMemo);
  }

  @override
  Future<List<WeekMemo>> getWeekMemos(DateTime dateTime) async {
    return await _db.loadWeekMemos(dateTime);
  }

  @override
  Future<DayMemo> getDayMemo(DateTime date) async {
    return await _db.loadDayMemo(date);
  }

  @override
  saveDayMemo(DayMemo dayMemo) {
    _db.saveDayMemo(dayMemo);
  }

}