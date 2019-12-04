
import 'package:todo_app/presentation/App.dart';

class HasShownWeekScreenTutorialUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<bool> invoke() {
    return _prefsRepository.hasShownWeekScreenTutorial();
  }
}