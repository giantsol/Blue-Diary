
import 'package:todo_app/data/datasource/PetDataSource.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/repository/PetRepository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetDataSource _dataSource;

  const PetRepositoryImpl(this._dataSource);

  @override
  Future<List<Pet>> getAllPets() {
    return _dataSource.getAllPets();
  }

  @override
  void setPet(Pet pet) {
    _dataSource.setPet(pet);
  }
}