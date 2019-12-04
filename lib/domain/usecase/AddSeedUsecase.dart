
import 'package:todo_app/presentation/App.dart';

class AddSeedUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke(int count) {
    _prefsRepository.addSeed(count);
  }
}