
import 'package:todo_app/domain/entity/Pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getAllPets();
  void setPet(Pet pet);
  String getSelectedPetKey();
  void setSelectedPetKey(String key);
  Future<Pet> getSelectedPet();
}