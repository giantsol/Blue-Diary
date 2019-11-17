
import 'package:todo_app/domain/entity/World.dart';

class PetState {
  final PetViewState viewState;
  final int growthPainCount;
  final List<World> worlds;
  final bool showToBeContinued;

  const PetState({
    this.viewState = PetViewState.LOADING,
    this.growthPainCount = 0,
    this.worlds = const [],
    this.showToBeContinued = true,
  });

  PetState buildNew({
    PetViewState viewState,
    int growthPainCount,
    List<World> worlds,
    bool showToBeContinued,
  }) {
    return PetState(
      viewState: viewState ?? this.viewState,
      growthPainCount: growthPainCount ?? this.growthPainCount,
      worlds: worlds ?? this.worlds,
      showToBeContinued: showToBeContinued ?? this.showToBeContinued,
    );
  }
}

enum PetViewState {
  LOADING,
  NORMAL,
}