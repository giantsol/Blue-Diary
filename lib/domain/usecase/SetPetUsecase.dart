
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/presentation/App.dart';

class SetPetUsecase {
  final _petRepository = dependencies.petRepository;

  void invoke(Pet pet) {
    _petRepository.setPet(pet);
  }
}