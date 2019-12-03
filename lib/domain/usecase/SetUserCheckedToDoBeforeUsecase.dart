
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SetUserCheckedToDoBeforeUsecase {
  final PrefsRepository _prefsRepository;

  SetUserCheckedToDoBeforeUsecase(this._prefsRepository);

  void invoke() {
    _prefsRepository.setUserCheckedToDoBefore();
  }
}