
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/usecase/PetUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/pet/PetState.dart';

class PetBloc {
  final _state = BehaviorSubject<PetState>.seeded(PetState());
  PetState getInitialState() => _state.value;
  Stream<PetState> observeState() => _state.distinct();

  final PetUsecases _usecases = dependencies.petUsecases;

  PetBloc() {
    _initState();
  }

  Future<void> _initState() async {
    final seedCount = _usecases.getSeedCount();
    final allPets = await _usecases.getAllPets();
    final selectedPetKey = _usecases.getSelectedPetKey();

    _state.add(_state.value.buildNew(
      viewState: PetViewState.NORMAL,
      seedCount: seedCount,
      pets: allPets,
      selectedPetKey: selectedPetKey,
    ));
  }

  void onEggFabClicked() {
    final selectedPet = _state.value.selectedPet;
    final updated = selectedPet.buildNew(currentPhaseIndex: selectedPet.currentPhaseIndex + 1);
    _state.add(_state.value.buildNewSelectedPetUpdated(updated));

    _usecases.setPet(updated);
    _usecases.setSelectedPetKey(_state.value.selectedPetKey);
  }

  void onSeedFabClicked() {
    // todo: use seed counts
    final selectedPet = _state.value.selectedPet;
    final updated = selectedPet.buildNewExpIncreased();
    _state.add(_state.value.buildNewSelectedPetUpdated(updated));

    _usecases.setPet(updated);
  }

  void onPetPreviewClicked(Pet pet) {
    if (pet.key == _state.value.selectedPetKey) {
      _state.add(_state.value.buildNew(
        selectedPetKey: '',
      ));
      _usecases.setSelectedPetKey('');
    } else {
      final isPetActivated = pet.currentPhaseIndex != Pet.PHASE_INDEX_INACTIVE;
      _state.add(_state.value.buildNew(
        selectedPetKey: pet.key,
      ));
      _usecases.setSelectedPetKey(isPetActivated ? pet.key : '');
    }
  }

  void onBornPhaseIndexClicked(int index) {
    final selectedPet = _state.value.selectedPet;
    final maxSelectablePhaseIndex = selectedPet.maxSelectablePhaseIndex;
    if (index <= maxSelectablePhaseIndex) {
      final updated = selectedPet.buildNew(
        currentPhaseIndex: index,
      );
      _state.add(_state.value.buildNewSelectedPetUpdated(updated));

      _usecases.setPet(updated);
    }
  }

  void dispose() {

  }
}