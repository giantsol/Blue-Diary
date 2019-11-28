
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/data/datasource/PetDataSource.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetDataSource _dataSource;
  final AppPreferences _prefs;

  const PetRepositoryImpl(this._dataSource, this._prefs);

  @override
  Future<List<Pet>> getAllPets() {
    return _dataSource.getAllPets();
  }

  @override
  void setPet(Pet pet) {
    _dataSource.setPet(pet);
  }

  @override
  String getSelectedPetKey() {
    return _prefs.getSelectedPetKey();
  }

  @override
  void setSelectedPetKey(String key) {
    _prefs.setSelectedPetKey(key);
  }

  @override
  Future<Pet> getSelectedPet() async {
    final selectedPetKey = getSelectedPetKey();
    if (selectedPetKey.isEmpty) {
      return Pet.INVALID;
    } else {
      return _dataSource.getPet(selectedPetKey);
    }
  }
}