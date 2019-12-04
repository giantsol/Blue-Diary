
import 'package:todo_app/presentation/App.dart';

class CanUpdateMyRankingUserInfoUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  bool invoke() {
    final lastUpdatedLocalTimeMillis = _prefsRepository.getLastUpdatedMyRankingUserInfoLocalTimeMillis();
    final currentLocalTimeMillis = DateTime.now().millisecondsSinceEpoch;
    // 5 minutes
    return (currentLocalTimeMillis - lastUpdatedLocalTimeMillis).abs() > 5 * 60 * 1000;
  }
}