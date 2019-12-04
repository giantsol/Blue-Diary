
import 'package:todo_app/presentation/App.dart';

class SetShownWeekScreenTutorialUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke() {
    _prefsRepository.setShownWeekScreenTutorial();
  }
}