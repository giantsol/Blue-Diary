
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SetShownFirstCompletableDayTutorialUsecase {
  final PrefsRepository _prefsRepository;

  SetShownFirstCompletableDayTutorialUsecase(this._prefsRepository);

  void invoke() {
    _prefsRepository.setShownFirstCompletableDayTutorial();
  }
}