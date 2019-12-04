
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/Pet.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/pet/PetBloc.dart';
import 'package:todo_app/presentation/pet/PetState.dart';

class PetScreen extends StatefulWidget {
  @override
  State createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  PetBloc _bloc;

  @override
  void initState() {
    super.initState();
    final deps = dependencies;
    _bloc = PetBloc(deps.prefsRepository, deps.petRepository, deps.userRepository, deps.toDoRepository, deps.rankingRepository, deps.dateRepository);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  Widget _buildUI(PetState state) {
    return Stack(
      children: <Widget>[
        state.viewState == PetViewState.LOADING ? _WholeLoadingView()
          : Column(
          children: <Widget>[
            _Header(
              bloc: _bloc,
              seedCount: state.seedCount,
              selectedPet: state.selectedPet,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 36, top: 40,),
                    child: Text(
                      'Pets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.TEXT_BLACK,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, top: 12, right: 24,),
                      child: GridView.count(
                        crossAxisCount: 4,
                        children: List.generate(state.pets.length, (index) {
                          final pet = state.pets[index];
                          return _PetPreview(
                            bloc: _bloc,
                            pet: pet,
                            isSelected: state.selectedPetKey == pet.key,
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        _FAB(
          bloc: _bloc,
          state: state.fabState,
        ),
      ],
    );
  }
}

class _WholeLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BACKGROUND_WHITE,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}

class _Header extends StatelessWidget {
  final PetBloc bloc;
  final int seedCount;
  final Pet selectedPet;

  _Header({
    @required this.bloc,
    @required this.seedCount,
    @required this.selectedPet,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184,
      child: Column(
        children: <Widget>[
          Container(
            height: 56,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: _SeedCount(seedCount),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
              child: Center(
                child: selectedPet == null ? Text(
                  AppLocalizations.of(context).noPetSelected,
                  style: TextStyle(
                    color: AppColors.TEXT_BLACK_LIGHT,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ): _SelectedPetView(
                  bloc: bloc,
                  pet: selectedPet
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SeedCount extends StatelessWidget {
  final int count;

  _SeedCount(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12,),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/ic_seed.png'),
          const SizedBox(width: 12,),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.TEXT_WHITE,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedPetView extends StatelessWidget {
  final PetBloc bloc;
  final Pet pet;

  _SelectedPetView({
    @required this.bloc,
    @required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    final currentPhase = pet.currentPhase;
    final double petMaxSize = 108;
    final double petSize = petMaxSize * currentPhase.sizeRatio;

    return Row(
      children: <Widget>[
        Container(
          width: petMaxSize,
          height: petMaxSize,
          child: Align(
            alignment: currentPhase.alignment,
            child: SizedBox(
              width: petSize,
              height: petSize,
              //todo: change to flare
              child: Image.asset(
                currentPhase.imgPath,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).getPetTitle(pet),
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.TEXT_BLACK,
                ),
              ),
              const SizedBox(height: 2,),
              Text(
                AppLocalizations.of(context).getPetSubtitle(pet),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.TEXT_BLACK_LIGHT,
                ),
              ),
              const Spacer(),
              _Phases(
                bloc: bloc,
                pet: pet,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Phases extends StatelessWidget {
  final PetBloc bloc;
  final Pet pet;

  _Phases({
    @required this.bloc,
    @required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    final maxSelectablePhaseIndex = pet.maxSelectablePhaseIndex;

    final double barBgWidthFactor = maxSelectablePhaseIndex == Pet.PHASE_INDEX_INACTIVE ? 0
      : maxSelectablePhaseIndex == Pet.PHASE_INDEX_EGG || pet.bornPhases.length == 2 || maxSelectablePhaseIndex >= 1 ? 1
      : 0.5;
    final double barFgWidthFactor = maxSelectablePhaseIndex == Pet.PHASE_INDEX_INACTIVE ? 0
      : maxSelectablePhaseIndex == Pet.PHASE_INDEX_EGG ? pet.exp / pet.eggPhase.maxExp
      : pet.bornPhases.length == 2 ? (pet.exp - pet.eggPhase.maxExp) / pet.bornPhases[0].maxExp
      : maxSelectablePhaseIndex == 0 ? 0.5 * (pet.exp - pet.eggPhase.maxExp) / pet.bornPhases[0].maxExp
      : 0.5 + 0.5 * (pet.exp - pet.eggPhase.maxExp - pet.bornPhases[0].maxExp) / pet.bornPhases[1].maxExp;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // phase bar graph
            Container(
              height: 12,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      color: AppColors.BACKGROUND_GREY,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: barBgWidthFactor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        color: AppColors.PRIMARY_LIGHT,
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: barFgWidthFactor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        color: AppColors.PRIMARY,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            maxSelectablePhaseIndex >= 0 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(pet.bornPhases.length, (index) {
                final phase = pet.bornPhases[index];
                final double maxSize = 36;
                final double petSize = 36 * phase.sizeRatio;
                return GestureDetector(
                  onTap: () => bloc.onBornPhaseIndexClicked(index),
                  child: Container(
                    width: maxSize,
                    height: maxSize,
                    child: Align(
                      alignment: phase.alignment,
                      child: SizedBox(
                        width: petSize,
                        height: petSize,
                        child: Image.asset(
                          phase.imgPath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ) : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 2,),
        Stack(
          children: <Widget>[
            _getPhaseScoreView(),
            maxSelectablePhaseIndex >= 0 ? Align(
              alignment: pet.currentPhaseIndex == 0 ? Alignment.topLeft
                : pet.currentPhaseIndex == 1 && pet.bornPhases.length == 2 ? Alignment.topRight
                : pet.currentPhaseIndex == 1 ? Alignment.topCenter
                : Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.asset('assets/ic_selected_phase.png'),
              ),
            ) : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }

  Widget _getPhaseScoreView() {
    final maxSelectablePhaseIndex = pet.maxSelectablePhaseIndex;
    final numerator = maxSelectablePhaseIndex == Pet.PHASE_INDEX_EGG ? pet.exp
      : maxSelectablePhaseIndex == 0 ? pet.exp - pet.eggPhase.maxExp
      : maxSelectablePhaseIndex == 1 && pet.bornPhases.length == 3 ? pet.exp - pet.eggPhase.maxExp - pet.bornPhases[0].maxExp
      : 0;
    final denominator = maxSelectablePhaseIndex == Pet.PHASE_INDEX_EGG ? pet.eggPhase.maxExp
      : maxSelectablePhaseIndex == 0 ? pet.bornPhases[0].maxExp
      : maxSelectablePhaseIndex == 1 && pet.bornPhases.length == 3 ? pet.bornPhases[1].maxExp
      : 0;

    final phaseScoreText = RichText(
      strutStyle: StrutStyle(
        fontSize: 12,
      ),
      text: denominator != 0 ? TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: AppColors.PRIMARY_LIGHT,
        ),
        children: [
          TextSpan(
            text: '$numerator',
            style: TextStyle(
              color: AppColors.PRIMARY,
            ),
          ),
          TextSpan(
            text: ' / $denominator',
          ),
        ],
      ) : TextSpan(
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      textScaleFactor: 1.0,
    );

    return maxSelectablePhaseIndex == 1 && pet.bornPhases.length == 3 ? Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Center(
          child: phaseScoreText,
        ),
      ),
    ) : maxSelectablePhaseIndex == 0 ? FractionallySizedBox(
      widthFactor: 0.5,
      child: Center(
        child: phaseScoreText,
      ),
    ) : Center(
      child: phaseScoreText,
    );
  }
}

class _FAB extends StatelessWidget {
  final PetBloc bloc;
  final FabState state;

  _FAB({
    @required this.bloc,
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return state != FabState.HIDDEN ? Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 16,),
        child: FloatingActionButton(
          child: Image.asset(state == FabState.SEED ? 'assets/ic_seed.png' : 'assets/ic_egg.png'),
          backgroundColor: AppColors.PRIMARY,
          splashColor: AppColors.PRIMARY_DARK,
          onPressed: () => state == FabState.EGG ? bloc.onEggFabClicked() : bloc.onSeedFabClicked(),
        ),
      ),
    ) : const SizedBox.shrink();
  }
}

class _PetPreview extends StatelessWidget {
  final PetBloc bloc;
  final Pet pet;
  final bool isSelected;

  _PetPreview({
    @required this.bloc,
    @required this.pet,
    @required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bloc.onPetPreviewClicked(pet),
      child: Container(
        alignment: Alignment.center,
        color: isSelected && pet.currentPhaseIndex == Pet.PHASE_INDEX_INACTIVE ? AppColors.BACKGROUND_GREY
          : isSelected ? AppColors.PRIMARY_LIGHT
          : AppColors.BACKGROUND_WHITE,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Image.asset(
            pet.currentPhase.imgPath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
