
import 'package:todo_app/domain/repository/PrefRepository.dart';

class AddSeedUsecase {
  final PrefsRepository _prefsRepository;

  AddSeedUsecase(this._prefsRepository);

  void invoke(int count) {
    _prefsRepository.addSeed(count);
  }
}