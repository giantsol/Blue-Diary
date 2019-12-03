
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';

class GetSelectedPetUsecase {
  final PetRepository _petRepository;

  GetSelectedPetUsecase(this._petRepository);

  Future<Pet> invoke() {
    return _petRepository.getSelectedPet();
  }
}