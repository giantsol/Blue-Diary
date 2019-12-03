
import 'package:todo_app/domain/repository/PetRepository.dart';

class SetSelectedPetKeyUsecase {
  final PetRepository _petRepository;

  SetSelectedPetKeyUsecase(this._petRepository);

  void invoke(String petKey) {
    _petRepository.setSelectedPetKey(petKey);
  }
}