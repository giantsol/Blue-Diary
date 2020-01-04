
import 'package:todo_app/presentation/App.dart';

class MinusSeedUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<void> invoke(int count) {
    return _prefsRepository.minusSeed(count);
  }
}