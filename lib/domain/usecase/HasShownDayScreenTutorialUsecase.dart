
import 'package:todo_app/domain/repository/PrefRepository.dart';

class HasShownDayScreenTutorialUsecase {
  final PrefsRepository _prefsRepository;

  HasShownDayScreenTutorialUsecase(this._prefsRepository);

  Future<bool> invoke() {
    return _prefsRepository.hasShownDayScreenTutorial();
  }
}