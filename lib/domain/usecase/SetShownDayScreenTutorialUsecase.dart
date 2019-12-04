
import 'package:todo_app/presentation/App.dart';

class SetShownDayScreenTutorialUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke() {
    _prefsRepository.setShownDayScreenTutorial();
  }
}