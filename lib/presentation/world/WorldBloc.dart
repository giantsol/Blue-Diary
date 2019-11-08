
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/Friend.dart';
import 'package:todo_app/domain/entity/World.dart';
import 'package:todo_app/presentation/world/WorldState.dart';

class WorldBloc {
  final _state = BehaviorSubject<WorldState>.seeded(WorldState());
  WorldState getInitialState() => _state.value;
  Stream<WorldState> observeState() => _state.distinct();

  WorldBloc(World world) {
    _initState(world);
  }

  Future<void> _initState(World world) async {
    final friends = [
      Friend(
        key: Friend.KEY_MIMIC,
      ),
      Friend(
        key: Friend.KEY_MIMIC,
      ),
    ];
    _state.add(_state.value.buildNew(
      worldKey: world.key,
      bgPath: world.bgPath,
      friends: friends,
    ));
  }

  void onBackFABClicked(BuildContext context) {

  }

  void dispose() {

  }
}