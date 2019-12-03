
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SetShownWeekScreenTutorialUsecase {
  final PrefsRepository _prefsRepository;

  SetShownWeekScreenTutorialUsecase(this._prefsRepository);

  void invoke() {
    _prefsRepository.setShownWeekScreenTutorial();
  }
}