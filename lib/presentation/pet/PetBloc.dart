
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/usecase/GetAllPetsUsecase.dart';
import 'package:todo_app/domain/usecase/GetSeedCountUsecase.dart';
import 'package:todo_app/domain/usecase/GetSelectedPetKeyUsecase.dart';
import 'package:todo_app/domain/usecase/MinusSeedUsecase.dart';
import 'package:todo_app/domain/usecase/SetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SetPetUsecase.dart';
import 'package:todo_app/domain/usecase/SetSelectedPetKeyUsecase.dart';
import 'package:todo_app/presentation/pet/PetState.dart';

class PetBloc {
  final _state = BehaviorSubject<PetState>.seeded(PetState());
  PetState getInitialState() => _state.value;
  Stream<PetState> observeState() => _state.distinct();

  final _getSeedCountUsecase = GetSeedCountUsecase();
  final _minusSeedUseCase = MinusSeedUsecase();
  final _getAllPetsUsecase = GetAllPetsUsecase();
  final _getSelectedPetKeyUsecase = GetSelectedPetKeyUsecase();
  final _setPetUsecase = SetPetUsecase();
  final _setSelectedPetKeyUsecase = SetSelectedPetKeyUsecase();
  final _setMyRankingUserInfoUsecase = SetMyRankingUserInfoUsecase();

  PetBloc() {
    _initState();
  }

  Future<void> _initState() async {
    final seedCount = _getSeedCountUsecase.invoke();
    final allPets = await _getAllPetsUsecase.invoke();
    final selectedPetKey = _getSelectedPetKeyUsecase.invoke();

    _state.add(_state.value.buildNew(
      viewState: PetViewState.NORMAL,
      seedCount: seedCount,
      pets: allPets,
      selectedPetKey: selectedPetKey,
    ));
  }

  Future<void> onEggFabClicked() async {
    final selectedPet = _state.value.selectedPet;
    final updated = selectedPet.buildNew(currentPhaseIndex: Pet.PHASE_INDEX_EGG);
    _state.add(_state.value.buildNewSelectedPetUpdated(updated)
      .buildNew(seedCount: _state.value.seedCount - 1)
    );

    _minusSeedUseCase.invoke(1);

    await _setPetUsecase.invoke(updated);
    await _setSelectedPetKeyUsecase.invoke(updated.key);
    _setMyRankingUserInfoUsecase.invoke();
  }

  Future<void> onSeedFabClicked() async {
    final selectedPet = _state.value.selectedPet;
    final prevPhaseIndex = selectedPet.currentPhaseIndex;
    final updated = selectedPet.buildNewExpIncreased();
    final updatedPhaseIndex = updated.currentPhaseIndex;
    _state.add(_state.value.buildNewSelectedPetUpdated(updated)
      .buildNew(seedCount: _state.value.seedCount - 1)
    );

    _minusSeedUseCase.invoke(1);

    await _setPetUsecase.invoke(updated);
    if (prevPhaseIndex != updatedPhaseIndex) {
      _setMyRankingUserInfoUsecase.invoke();
    }
  }

  Future<void> onPetPreviewClicked(Pet pet) async {
    if (pet.key == _state.value.selectedPetKey) {
      _state.add(_state.value.buildNew(
        selectedPetKey: '',
      ));
      await _setSelectedPetKeyUsecase.invoke('');
    } else {
      final isPetActivated = pet.currentPhaseIndex != Pet.PHASE_INDEX_INACTIVE;
      _state.add(_state.value.buildNew(
        selectedPetKey: pet.key,
      ));
      await _setSelectedPetKeyUsecase.invoke(isPetActivated ? pet.key : '');
    }

    _setMyRankingUserInfoUsecase.invoke();
  }

  Future<void> onBornPhaseIndexClicked(int index) async {
    final selectedPet = _state.value.selectedPet;
    final maxSelectablePhaseIndex = selectedPet.maxSelectablePhaseIndex;
    if (index <= maxSelectablePhaseIndex) {
      final updated = selectedPet.buildNew(currentPhaseIndex: index);
      _state.add(_state.value.buildNewSelectedPetUpdated(updated));

      await _setPetUsecase.invoke(updated);
      _setMyRankingUserInfoUsecase.invoke();
    }
  }

  void dispose() {

  }
}