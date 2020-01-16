
import 'package:todo_app/domain/entity/Pet.dart';

class PetState {
  final PetViewState viewState;
  final int seedCount;
  final List<Pet> pets;
  final String selectedPetKey;

  Pet get selectedPet => pets.firstWhere((it) => it.key == selectedPetKey, orElse: () => Pet.INVALID);
  FabState get fabState {
    final selected = selectedPet;
    return !selected.isValid || selected.hasReachedFullLevel ? FabState.HIDDEN
      : selected.currentPhaseIndex == Pet.PHASE_INDEX_INACTIVE ? (seedCount > 0 ? FabState.EGG : FabState.EGG_INACTIVE)
      : (seedCount > 0 ? FabState.SEED : FabState.SEED_INACTIVE);
  }

  const PetState({
    this.viewState = PetViewState.LOADING,
    this.seedCount = 0,
    this.pets = const [],
    this.selectedPetKey = '',
  });

  PetState buildNew({
    PetViewState viewState,
    int seedCount,
    List<Pet> pets,
    String selectedPetKey,
  }) {
    return PetState(
      viewState: viewState ?? this.viewState,
      seedCount: seedCount ?? this.seedCount,
      pets: pets ?? this.pets,
      selectedPetKey: selectedPetKey ?? this.selectedPetKey,
    );
  }

  PetState buildNewSelectedPetUpdated(Pet updated) {
    final updatedIndex = pets.indexWhere((it) => it.key == updated.key);
    if (updatedIndex >= 0) {
      final updatedPets = List.of(pets);
      updatedPets[updatedIndex] = updated;
      return buildNew(
        pets: updatedPets,
      );
    } else {
      return buildNew();
    }
  }
}

enum PetViewState {
  LOADING,
  NORMAL,
}

enum FabState {
  HIDDEN,
  EGG,
  EGG_INACTIVE,
  SEED,
  SEED_INACTIVE,
}