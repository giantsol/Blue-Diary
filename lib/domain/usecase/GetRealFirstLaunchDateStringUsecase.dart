
import 'package:todo_app/presentation/App.dart';

class GetRealFirstLaunchDateStringUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<String> invoke() {
    return _prefsRepository.getRealFirstLaunchDateString();
  }
}