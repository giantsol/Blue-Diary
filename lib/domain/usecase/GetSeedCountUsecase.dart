
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetSeedCountUsecase {
  final PrefsRepository _prefsRepository;

  GetSeedCountUsecase(this._prefsRepository);

  int invoke() {
    return _prefsRepository.getSeedCount();
  }
}