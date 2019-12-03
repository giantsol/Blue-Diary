
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SetShownDayScreenTutorialUsecase {
  final PrefsRepository _prefsRepository;

  SetShownDayScreenTutorialUsecase(this._prefsRepository);

  void invoke() {
    _prefsRepository.setShownDayScreenTutorial();
  }
}