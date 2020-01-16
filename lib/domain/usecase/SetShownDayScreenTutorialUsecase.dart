
import 'package:todo_app/presentation/App.dart';

class SetShownDayScreenTutorialUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke() {
    return _prefsRepository.setShownDayScreenTutorial();
  }
}