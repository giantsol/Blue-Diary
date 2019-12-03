
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SetUseLockScreenUsecase {
  final PrefsRepository _prefsRepository;

  SetUseLockScreenUsecase(this._prefsRepository);

  void invoke(bool value) {
    _prefsRepository.setUseLockScreen(value);
  }
}