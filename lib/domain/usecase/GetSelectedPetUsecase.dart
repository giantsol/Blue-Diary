
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/presentation/App.dart';

class GetSelectedPetUsecase {
  final _petRepository = dependencies.petRepository;

  Future<Pet> invoke() {
    return _petRepository.getSelectedPet();
  }
}