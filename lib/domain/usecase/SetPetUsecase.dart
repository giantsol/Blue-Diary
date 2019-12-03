
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';

class SetPetUsecase {
  final PetRepository _petRepository;

  SetPetUsecase(this._petRepository);

  void invoke(Pet pet) {
    _petRepository.setPet(pet);
  }
}