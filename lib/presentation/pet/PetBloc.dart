
import 'package:rxdart/rxdart.dart';
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
    _state.add(_state.value.buildNew(
      viewState: PetViewState.NORMAL,
    ));
  }

  void dispose() {

  }
}