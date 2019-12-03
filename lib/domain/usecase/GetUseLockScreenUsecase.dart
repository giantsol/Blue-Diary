
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetUseLockScreenUsecase {
  final PrefsRepository _prefsRepository;

  GetUseLockScreenUsecase(this._prefsRepository);

  Future<bool> invoke() {
    return _prefsRepository.getUseLockScreen();
  }
}