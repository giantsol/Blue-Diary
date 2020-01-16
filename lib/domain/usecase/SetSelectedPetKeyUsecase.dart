
import 'package:todo_app/presentation/App.dart';

class SetSelectedPetKeyUsecase {
  final _petRepository = dependencies.petRepository;

  Future<void> invoke(String petKey) {
    return _petRepository.setSelectedPetKey(petKey);
  }
}