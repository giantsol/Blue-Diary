
import 'package:todo_app/presentation/App.dart';

class GetSelectedPetKeyUsecase {
  final _petRepository = dependencies.petRepository;

  String invoke() {
    return _petRepository.getSelectedPetKey();
  }
}