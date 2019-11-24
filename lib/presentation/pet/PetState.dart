
class PetState {
  final PetViewState viewState;
  final int seedCount;
  final SelectedPet selectedPet;
  final List<PetPreview> petPreviews;
  final FabState fabState;

  const PetState({
    this.viewState = PetViewState.LOADING,
    this.seedCount = 0,
    this.selectedPet,
    this.petPreviews = const [],
    this.fabState = FabState.HIDDEN,
  });

  PetState buildNew({
    PetViewState viewState,
    int seedCount,
    SelectedPet selectedPet,
    List<PetPreview> petPreviews,
    FabState fabState,
  }) {
    return PetState(
      viewState: viewState ?? this.viewState,
      seedCount: seedCount ?? this.seedCount,
      selectedPet: selectedPet ?? this.selectedPet,
      petPreviews: petPreviews ?? this.petPreviews,
      fabState: fabState ?? this.fabState,
    );
  }
}

enum PetViewState {
  LOADING,
  NORMAL,
}

class SelectedPet {
  final String key; // key used for getting title, subtitle etc from Localizations
  final String flrPath;
  final String flrAnimation;
  final bool isActivated;
  final bool isHatching;
  final List<Phase> phases;
  final int selectedPhase;

  const SelectedPet({
    this.key = '',
    this.flrPath = '',
    this.flrAnimation = '',
    this.isActivated = false,
    this.isHatching = false,
    this.phases = const [],
    this.selectedPhase = 0,
  });
}

class Phase {
  final String imgPath;
  final int maxExp;
  final int curExp;

  bool get isFull => curExp == maxExp;

  const Phase({
    this.imgPath = '',
    this.maxExp = 0,
    this.curExp = 0,
  });
}

class PetPreview {
  final String imgPath;
  final bool isSelected;
  final bool isActivated;

  const PetPreview({
    this.imgPath = '',
    this.isSelected = false,
    this.isActivated = false,
  });
}

enum FabState {
  HIDDEN,
  EGG,
  SEED,
}