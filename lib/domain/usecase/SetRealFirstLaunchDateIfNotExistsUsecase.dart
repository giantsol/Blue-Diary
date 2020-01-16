
import 'package:todo_app/domain/usecase/GetRealFirstLaunchDateStringUsecase.dart';
import 'package:todo_app/presentation/App.dart';

class SetRealFirstLaunchDateIfNotExistsUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  final _getRealFirstLaunchDateStringUsecase = GetRealFirstLaunchDateStringUsecase();

  Future<void> invoke(DateTime date) async {
    final savedValue = await _getRealFirstLaunchDateStringUsecase.invoke();
    if (savedValue.isEmpty) {
      _prefsRepository.setRealFirstLaunchDate(date);
    }
  }
}