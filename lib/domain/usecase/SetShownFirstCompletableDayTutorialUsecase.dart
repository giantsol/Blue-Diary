
import 'package:todo_app/presentation/App.dart';

class SetShownFirstCompletableDayTutorialUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke() {
    return _prefsRepository.setShownFirstCompletableDayTutorial();
  }
}