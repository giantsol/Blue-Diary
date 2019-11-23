
class PetState {
  final PetViewState viewState;
  final int growthPainCount;

  const PetState({
    this.viewState = PetViewState.LOADING,
    this.growthPainCount = 0,
  });

  PetState buildNew({
    PetViewState viewState,
    int growthPainCount,
  }) {
    return PetState(
      viewState: viewState ?? this.viewState,
      growthPainCount: growthPainCount ?? this.growthPainCount,
    );
  }
}

enum PetViewState {
  LOADING,
  NORMAL,
}