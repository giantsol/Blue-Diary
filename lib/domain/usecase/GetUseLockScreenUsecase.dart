
import 'package:todo_app/presentation/App.dart';

class GetUseLockScreenUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<bool> invoke() {
    return _prefsRepository.getUseLockScreen();
  }
}