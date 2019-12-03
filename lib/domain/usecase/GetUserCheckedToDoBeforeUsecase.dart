
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetUserCheckedToDoBeforeUsecase {
  final PrefsRepository _prefsRepository;

  GetUserCheckedToDoBeforeUsecase(this._prefsRepository);

  Future<bool> invoke() {
    return _prefsRepository.getUserCheckedToDoBefore();
  }
}