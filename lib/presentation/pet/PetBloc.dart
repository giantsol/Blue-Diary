
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/World.dart';
import 'package:todo_app/domain/usecase/PetUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/pet/PetState.dart';
import 'package:todo_app/presentation/world/WorldScreen.dart';

class PetBloc {
  final _state = BehaviorSubject<PetState>.seeded(PetState());
  PetState getInitialState() => _state.value;
  Stream<PetState> observeState() => _state.distinct();

  final PetUsecases _usecases = dependencies.petUsecases;

  PetBloc() {
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

    _state.add(_state.value.buildNew(
      viewState: PetViewState.NORMAL,
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