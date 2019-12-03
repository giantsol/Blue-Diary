
import 'package:todo_app/domain/repository/PetRepository.dart';

class GetSelectedPetKeyUsecase {
  final PetRepository _petRepository;

  GetSelectedPetKeyUsecase(this._petRepository);

  String invoke() {
    return _petRepository.getSelectedPetKey();
  }
}