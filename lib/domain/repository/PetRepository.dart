
import 'package:todo_app/domain/entity/Pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getAllPets();
  Future<void> setPet(Pet pet);
  String getSelectedPetKey();
  Future<void> setSelectedPetKey(String key);
  Future<Pet> getSelectedPet();
}