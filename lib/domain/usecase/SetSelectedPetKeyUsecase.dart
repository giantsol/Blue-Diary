
import 'package:todo_app/presentation/App.dart';

class SetSelectedPetKeyUsecase {
  final _petRepository = dependencies.petRepository;

  void invoke(String petKey) {
    _petRepository.setSelectedPetKey(petKey);
  }
}