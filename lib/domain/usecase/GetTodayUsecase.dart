
import 'package:todo_app/domain/repository/DateRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetTodayUsecase {
  final DateRepository _dateRepository;
  final PrefsRepository _prefsRepository;

  GetTodayUsecase(this._dateRepository, this._prefsRepository);

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