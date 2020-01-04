
import 'package:todo_app/presentation/App.dart';

class SetUseLockScreenUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke(bool value) {
    return _prefsRepository.setUseLockScreen(value);
  }
}