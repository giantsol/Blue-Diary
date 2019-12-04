
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/domain/usecase/CanUpdateMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/GetAllPetsUsecase.dart';
import 'package:todo_app/domain/usecase/GetSeedCountUsecase.dart';
import 'package:todo_app/domain/usecase/GetSelectedPetKeyUsecase.dart';
import 'package:todo_app/domain/usecase/SetMyRankingUserInfoUsecase.dart';
import 'package:todo_app/domain/usecase/SetPetUsecase.dart';
import 'package:todo_app/domain/usecase/SetSelectedPetKeyUsecase.dart';
import 'package:todo_app/presentation/pet/PetState.dart';

class PetBloc {
  final _state = BehaviorSubject<PetState>.seeded(PetState());
  PetState getInitialState() => _state.value;
  Stream<PetState> observeState() => _state.distinct();

  final _getSeedCountUsecase = GetSeedCountUsecase();
  final _getAllPetsUsecase = GetAllPetsUsecase();
  final _getSelectedPetKeyUsecase = GetSelectedPetKeyUsecase();
  final _setPetUsecase = SetPetUsecase();
  final _setSelectedPetKeyUsecase = SetSelectedPetKeyUsecase();
  final _canUpdateMyRankingUserInfoUsecase = CanUpdateMyRankingUserInfoUsecase();
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

  void onEggFabClicked() {
    final selectedPet = _state.value.selectedPet;
    final updated = selectedPet.buildNew(currentPhaseIndex: selectedPet.currentPhaseIndex + 1);
    _state.add(_state.value.buildNewSelectedPetUpdated(updated));

    _setPetUsecase.invoke(updated);
    _setSelectedPetKeyUsecase.invoke(_state.value.selectedPetKey);

    final canUpdateMyRankingUserInfo = _canUpdateMyRankingUserInfoUsecase.invoke();
    if (canUpdateMyRankingUserInfo) {
      _setMyRankingUserInfoUsecase.invoke();
    }
  }

  void onSeedFabClicked() {
    // todo: use seed counts
    final selectedPet = _state.value.selectedPet;
    final prevPhaseIndex = selectedPet.currentPhaseIndex;
    final updated = selectedPet.buildNewExpIncreased();
    final updatedPhaseIndex = updated.currentPhaseIndex;
    _state.add(_state.value.buildNewSelectedPetUpdated(updated));

    _setPetUsecase.invoke(updated);

    if (prevPhaseIndex != updatedPhaseIndex) {
      final canUpdateMyRankingUserInfo = _canUpdateMyRankingUserInfoUsecase.invoke();
      if (canUpdateMyRankingUserInfo) {
        _setMyRankingUserInfoUsecase.invoke();
      }
    }
  }

  void onPetPreviewClicked(Pet pet) {
    if (pet.key == _state.value.selectedPetKey) {
      _state.add(_state.value.buildNew(
        selectedPetKey: '',
      ));
      _setSelectedPetKeyUsecase.invoke('');
    } else {
      final isPetActivated = pet.currentPhaseIndex != Pet.PHASE_INDEX_INACTIVE;
      _state.add(_state.value.buildNew(
        selectedPetKey: pet.key,
      ));
      _setSelectedPetKeyUsecase.invoke(isPetActivated ? pet.key : '');
    }

    final canUpdateMyRankingUserInfo = _canUpdateMyRankingUserInfoUsecase.invoke();
    if (canUpdateMyRankingUserInfo) {
      _setMyRankingUserInfoUsecase.invoke();
    }
  }

  void onBornPhaseIndexClicked(int index) {
    final selectedPet = _state.value.selectedPet;
    final maxSelectablePhaseIndex = selectedPet.maxSelectablePhaseIndex;
    if (index <= maxSelectablePhaseIndex) {
      final updated = selectedPet.buildNew(
        currentPhaseIndex: index,
      );
      _state.add(_state.value.buildNewSelectedPetUpdated(updated));

      _setPetUsecase.invoke(updated);

      final canUpdateMyRankingUserInfo = _canUpdateMyRankingUserInfoUsecase.invoke();
      if (canUpdateMyRankingUserInfo) {
        _setMyRankingUserInfoUsecase.invoke();
      }
    }
  }

  void dispose() {

  }
}