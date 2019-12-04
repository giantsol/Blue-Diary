
import 'package:todo_app/presentation/App.dart';

class GetUseRealFirstLaunchDateUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<bool> invoke() {
    return _prefsRepository.getUseRealFirstLaunchDate();
  }
}