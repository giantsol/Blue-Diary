
import 'package:todo_app/presentation/App.dart';

class AddSeedUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke(int count) {
    return _prefsRepository.addSeed(count);
  }
}