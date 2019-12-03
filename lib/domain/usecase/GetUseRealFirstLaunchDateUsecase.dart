
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetUseRealFirstLaunchDateUsecase {
  final PrefsRepository _prefsRepository;

  GetUseRealFirstLaunchDateUsecase(this._prefsRepository);

  Future<bool> invoke() {
    return _prefsRepository.getUseRealFirstLaunchDate();
  }
}