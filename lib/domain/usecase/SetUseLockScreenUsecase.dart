
import 'package:todo_app/presentation/App.dart';

class SetUseLockScreenUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke(bool value) {
    _prefsRepository.setUseLockScreen(value);
  }
}