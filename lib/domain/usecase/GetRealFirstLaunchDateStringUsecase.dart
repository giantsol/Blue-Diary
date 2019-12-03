
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetRealFirstLaunchDateStringUsecase {
  final PrefsRepository _prefsRepository;

  GetRealFirstLaunchDateStringUsecase(this._prefsRepository);

  Future<String> invoke() {
    return _prefsRepository.getRealFirstLaunchDateString();
  }
}