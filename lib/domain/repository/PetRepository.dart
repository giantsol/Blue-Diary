
import 'package:todo_app/domain/entity/Pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getAllPets();
  void setPet(Pet pet);
}