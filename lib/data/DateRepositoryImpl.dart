
import 'package:todo_app/domain/repository/DateRepository.dart';

class DateRepositoryImpl implements DateRepository {
  static final _today = DateTime.now();

  @override
  DateTime getToday() {
    return _today;
  }
}