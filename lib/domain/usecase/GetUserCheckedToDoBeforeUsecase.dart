
import 'package:todo_app/presentation/App.dart';

class GetUserCheckedToDoBeforeUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<bool> invoke() {
    return _prefsRepository.getUserCheckedToDoBefore();
  }
}