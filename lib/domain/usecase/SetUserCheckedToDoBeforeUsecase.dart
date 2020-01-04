
import 'package:todo_app/presentation/App.dart';

class SetUserCheckedToDoBeforeUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke() {
    return _prefsRepository.setUserCheckedToDoBefore();
  }
}