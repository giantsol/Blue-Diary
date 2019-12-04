
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/presentation/App.dart';

class GetAllPetsUsecase {
  final _petRepository = dependencies.petRepository;

  Future<List<Pet>> invoke() {
    return _petRepository.getAllPets();
  }
}