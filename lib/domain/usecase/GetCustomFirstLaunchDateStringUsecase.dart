
import 'package:todo_app/domain/repository/PrefRepository.dart';

class GetCustomFirstLaunchDateStringUsecase {
  final PrefsRepository _prefsRepository;

  GetCustomFirstLaunchDateStringUsecase(this._prefsRepository);

  Future<String> invoke() {
    return _prefsRepository.getCustomFirstLaunchDateString();
  }
}