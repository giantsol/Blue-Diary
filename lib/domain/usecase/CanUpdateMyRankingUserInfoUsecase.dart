
import 'package:todo_app/domain/repository/PrefRepository.dart';

class CanUpdateMyRankingUserInfoUsecase {
  final PrefsRepository _prefsRepository;

  CanUpdateMyRankingUserInfoUsecase(this._prefsRepository);

  bool invoke() {
    final lastUpdatedLocalTimeMillis = _prefsRepository.getLastUpdatedMyRankingUserInfoLocalTimeMillis();
    final currentLocalTimeMillis = DateTime.now().millisecondsSinceEpoch;
    // 5 minutes
    return (currentLocalTimeMillis - lastUpdatedLocalTimeMillis).abs() > 5 * 60 * 1000;
  }
}