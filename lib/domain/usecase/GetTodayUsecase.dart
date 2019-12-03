
import 'package:todo_app/domain/repository/DateRepository.dart';

class GetTodayUsecase {
  final DateRepository _dateRepository;

  GetTodayUsecase(this._dateRepository);

  Future<DateTime> invoke() {
    return _dateRepository.getToday();
  }
}