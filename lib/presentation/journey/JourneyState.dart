
import 'package:todo_app/domain/entity/World.dart';

class JourneyState {
  final JourneyViewState viewState;
  final int growthPainCount;
  final List<World> worlds;
  final bool showToBeContinued;

  const JourneyState({
    this.viewState = JourneyViewState.LOADING,
    this.growthPainCount = 0,
    this.worlds = const [],
    this.showToBeContinued = true,
  });

  JourneyState buildNew({
    JourneyViewState viewState,
    int growthPainCount,
    List<World> worlds,
    bool showToBeContinued,
  }) {
    return JourneyState(
      viewState: viewState ?? this.viewState,
      growthPainCount: growthPainCount ?? this.growthPainCount,
      worlds: worlds ?? this.worlds,
      showToBeContinued: showToBeContinued ?? this.showToBeContinued,
    );
  }
}

enum JourneyViewState {
  LOADING,
  NORMAL,
}