
import 'package:todo_app/presentation/App.dart';

class GetCustomFirstLaunchDateStringUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<String> invoke() {
    return _prefsRepository.getCustomFirstLaunchDateString();
  }
}