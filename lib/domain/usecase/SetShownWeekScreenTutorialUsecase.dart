
import 'package:todo_app/presentation/App.dart';

class SetShownWeekScreenTutorialUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke() {
    return _prefsRepository.setShownWeekScreenTutorial();
  }
}