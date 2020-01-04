
import 'package:todo_app/data/datasource/AppDatabase.dart';
import 'package:todo_app/data/datasource/AppPreferences.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';

class PetRepositoryImpl implements PetRepository {
  final AppDatabase _database;
  final AppPreferences _prefs;

  const PetRepositoryImpl(this._database, this._prefs);

  @override
  Future<List<Pet>> getAllPets() {
    return _database.getAllPets();
  }

  @override
  Future<void> setPet(Pet pet) {
    return _database.setPet(pet);
  }

  @override
  Future<String> getSelectedPetKey() {
    return _prefs.getSelectedPetKey();
  }

  @override
  Future<void> setSelectedPetKey(String key) {
    return _prefs.setSelectedPetKey(key);
  }

  @override
  Future<Pet> getSelectedPet() async {
    final selectedPetKey = await getSelectedPetKey();
    if (selectedPetKey.isEmpty) {
      return Pet.INVALID;
    } else {
      return _database.getPet(selectedPetKey);
    }
  }
}