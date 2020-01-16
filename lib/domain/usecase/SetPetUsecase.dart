
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/presentation/App.dart';

class SetPetUsecase {
  final _petRepository = dependencies.petRepository;

  Future<void> invoke(Pet pet) {
    return _petRepository.setPet(pet);
  }
}