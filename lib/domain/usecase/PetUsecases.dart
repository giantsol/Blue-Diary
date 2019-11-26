
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';
import 'package:todo_app/domain/repository/PrefRepository.dart';

class PetUsecases {
  final PetRepository _petRepository;
  final PrefsRepository _prefsRepository;

  const PetUsecases(this._petRepository, this._prefsRepository);

  int getSeedCount() {
    return _prefsRepository.getSeedCount();
  }

  Future<List<Pet>> getAllPets() {
    return _petRepository.getAllPets();
  }

  String getSelectedPetKey() {
    return _prefsRepository.getSelectedPetKey();
  }

  void setPet(Pet pet) {
    _petRepository.setPet(pet);
  }

  void setSelectedPetKey(String petKey) {
    _prefsRepository.setSelectedPetKey(petKey);
  }
}