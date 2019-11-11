
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/World.dart';
import 'package:todo_app/domain/usecase/JourneyUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/journey/JourneyState.dart';
import 'package:todo_app/presentation/world/WorldScreen.dart';

class JourneyBloc {
  final _state = BehaviorSubject<JourneyState>.seeded(JourneyState());
  JourneyState getInitialState() => _state.value;
  Stream<JourneyState> observeState() => _state.distinct();

  final JourneyUsecases _usecases = dependencies.journeyUsecases;

  JourneyBloc() {
    _initState();
  }

  Future<void> _initState() async {
    final worlds = [
      const World(
        key: World.KEY_BEGINNING,
        bgPath: 'assets/ic_settings.png',
      ),
      const World(
        key: World.KEY_GRASSLAND,
        bgPath: 'assets/ic_preview_todo.png',
      ),
    ];

    //todo: remove below debug code
    final completionRatio = await _usecases.getCompletionRatio();
    final currentStreakCount = await _usecases.getLatestStreakCount();
    final maxStreakCount = await _usecases.getMaxStreakCount();
    debugPrint('completionRatio: $completionRatio, currentStreak: $currentStreakCount, maxStreak: $maxStreakCount');

    _state.add(_state.value.buildNew(
      viewState: JourneyViewState.NORMAL,
      worlds: worlds,
    ));
  }

  void onWorldItemClicked(BuildContext context, World item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorldScreen(item),
      ),
    );
  }

  void dispose() {

  }
}