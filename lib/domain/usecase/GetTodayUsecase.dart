
import 'package:todo_app/presentation/App.dart';

class GetTodayUsecase {
  final _dateRepository = dependencies.dateRepository;

  Future<DateTime> invoke() {
    return _dateRepository.getToday();
  }
}