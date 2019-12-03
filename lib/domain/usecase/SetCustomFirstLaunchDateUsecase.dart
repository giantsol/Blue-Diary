
import 'package:todo_app/domain/repository/PrefRepository.dart';

class SetCustomFirstLaunchDateUsecase {
  final PrefsRepository _prefsRepository;

  SetCustomFirstLaunchDateUsecase(this._prefsRepository);

  void invoke(DateTime date) {
    _prefsRepository.setCustomFirstLaunchDate(date);
  }
}