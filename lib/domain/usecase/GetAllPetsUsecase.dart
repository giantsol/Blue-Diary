
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';

class GetAllPetsUsecase {
  final PetRepository _petRepository;

  GetAllPetsUsecase(this._petRepository);

  Future<List<Pet>> invoke() {
    return _petRepository.getAllPets();
  }
}