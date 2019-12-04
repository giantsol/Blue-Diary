
import 'package:todo_app/presentation/App.dart';

class SetCustomFirstLaunchDateUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke(DateTime date) {
    _prefsRepository.setCustomFirstLaunchDate(date);
  }
}