
import 'package:todo_app/domain/repository/PrefRepository.dart';
import 'package:todo_app/domain/usecase/GetRealFirstLaunchDateStringUsecase.dart';

class SetRealFirstLaunchDateIfNotExistsUsecase {
  final PrefsRepository _prefsRepository;

  final GetRealFirstLaunchDateStringUsecase _getRealFirstLaunchDateStringUsecase;

  SetRealFirstLaunchDateIfNotExistsUsecase(this._prefsRepository)
    : _getRealFirstLaunchDateStringUsecase = GetRealFirstLaunchDateStringUsecase(_prefsRepository);

  Future<void> invoke(DateTime date) async {
    final savedValue = await _getRealFirstLaunchDateStringUsecase.invoke();
    if (savedValue.isEmpty) {
      _prefsRepository.setRealFirstLaunchDate(date);
    }
  }
}