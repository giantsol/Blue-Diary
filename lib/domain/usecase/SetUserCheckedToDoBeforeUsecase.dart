
import 'package:todo_app/presentation/App.dart';

class SetUserCheckedToDoBeforeUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke() {
    _prefsRepository.setUserCheckedToDoBefore();
  }
}