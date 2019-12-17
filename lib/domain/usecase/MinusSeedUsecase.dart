
import 'package:todo_app/presentation/App.dart';

class MinusSeedUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  void invoke(int count) {
    _prefsRepository.minusSeed(count);
  }
}