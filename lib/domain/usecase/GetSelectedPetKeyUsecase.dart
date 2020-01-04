
import 'package:todo_app/presentation/App.dart';

class GetSelectedPetKeyUsecase {
  final _petRepository = dependencies.petRepository;

  Future<String> invoke() {
    return _petRepository.getSelectedPetKey();
  }
}