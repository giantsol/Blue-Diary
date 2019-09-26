
import 'package:todo_app/domain/repository/DateRepository.dart';

class DateRepositoryImpl implements DateRepository {
  static final _today = DateTime.now();

  DateTime _currentDate = _today;

  @override
  DateTime getToday() {
    return _today;
  }

  @override
  DateTime getCurrentDate() {
    return _currentDate;
  }

  @override
  void setCurrentDate(DateTime date) {
    _currentDate = date;
  }
}