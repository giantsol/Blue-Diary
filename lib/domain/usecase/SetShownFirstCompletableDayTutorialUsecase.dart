
import 'package:todo_app/presentation/App.dart';

class SetShownFirstCompletableDayTutorialUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke() {
    _prefsRepository.setShownFirstCompletableDayTutorial();
  }
}