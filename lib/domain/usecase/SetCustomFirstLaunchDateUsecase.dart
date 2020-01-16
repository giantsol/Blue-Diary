
import 'package:todo_app/presentation/App.dart';

class SetCustomFirstLaunchDateUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke(DateTime date) {
    return _prefsRepository.setCustomFirstLaunchDate(date);
  }
}