
import 'package:todo_app/presentation/App.dart';

class GetTodayUsecase {
  final _dateRepository = dependencies.dateRepository;
  final _prefsRepository = dependencies.prefsRepository;

  Future<DateTime> invoke() {
    final lastUpdatedLocalTimeMillis = _prefsRepository.getLastUpdatedTodayLocalTimeMillis();
    final currentLocalTimeMillis = DateTime.now().millisecondsSinceEpoch;
    // 5 minutes
    if((currentLocalTimeMillis - lastUpdatedLocalTimeMillis).abs() > 5 * 60 * 1000) {
      _prefsRepository.setLastUpdatedTodayLocalTimeMillis(currentLocalTimeMillis);
      _dateRepository.deleteCachedToday();
    }

    return _dateRepository.getToday();
  }
}