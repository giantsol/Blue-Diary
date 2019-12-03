
import 'package:todo_app/domain/repository/PrefRepository.dart';

class HasShownWeekScreenTutorialUsecase {
  final PrefsRepository _prefsRepository;

  HasShownWeekScreenTutorialUsecase(this._prefsRepository);

  Future<bool> invoke() {
    return _prefsRepository.hasShownWeekScreenTutorial();
  }
}