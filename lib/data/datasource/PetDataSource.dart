
import 'package:todo_app/domain/entity/Pet.dart';

abstract class PetDataSource {
  Future<List<Pet>> getAllPets();
  Future<void> setPet(Pet pet);
  Future<Pet> getPet(String key);
}