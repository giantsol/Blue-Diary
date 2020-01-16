
import 'package:todo_app/presentation/App.dart';

class GetSeedCountUsecase {
  final _prefsRepository = dependencies.prefsRepository;

  Future<int> invoke() {
    return _prefsRepository.getSeedCount();
  }
}