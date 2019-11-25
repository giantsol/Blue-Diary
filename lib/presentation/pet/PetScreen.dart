
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
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
    _bloc = PetBloc();
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
                        children: List.generate(state.petPreviews.length, (index) {
                          return _PetPreview(
                            item: state.petPreviews[index],
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
  final int seedCount;
  final SelectedPet selectedPet;

  _Header({
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
                ): _SelectedPetView(selectedPet),
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
  final SelectedPet selectedPet;

  _SelectedPetView(this.selectedPet);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 108,
          height: 108,
          child: FlareActor(
            selectedPet.flrPath,
            animation: selectedPet.flrAnimation,
          ),
        ),
        const SizedBox(width: 8,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).getPetTitle(
                  selectedPet.key,
                  selectedPet.selectedPhase,
                  selectedPet.isActivated,
                  selectedPet.isHatching
                ),
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.TEXT_BLACK,
                ),
              ),
              const SizedBox(height: 2,),
              Text(
                AppLocalizations.of(context).getPetSubtitle(
                  selectedPet.key,
                  selectedPet.selectedPhase,
                  selectedPet.isActivated,
                  selectedPet.isHatching
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.TEXT_BLACK_LIGHT,
                ),
              ),
              const Spacer(),
              _Phases(
                phases: selectedPet.phases,
                selectedPhase: selectedPet.selectedPhase,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Phases extends StatelessWidget {
  final List<Phase> phases;
  final int selectedPhase;

  _Phases({
    @required this.phases,
    @required this.selectedPhase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _PhaseBar(
              phases: phases,
            ),
            phases.length >= 2 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(phases.length, (index) {
                return SizedBox(
                  width: 36,
                  height: 36,
                  child: Image.asset(phases[index].imgPath),
                );
              }),
            ) : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 2,),
        Stack(
          children: <Widget>[
            _getPhaseScoreView(),
            phases.length >= 2 && selectedPhase >= 0 ? Align(
              alignment: phases.length == 3 && selectedPhase == 0 ? Alignment.topLeft
                : phases.length == 3 && selectedPhase == 1 ? Alignment.topCenter
                : phases.length == 3 ? Alignment.topRight
                : phases.length == 2 && selectedPhase == 0 ? Alignment.topLeft
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
    final phaseScoreText = RichText(
      strutStyle: StrutStyle(
        fontSize: 12,
      ),
      text: phases.length == 3 ? TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: AppColors.PRIMARY_LIGHT,
        ),
        children: [
          TextSpan(
            text: '${phases[0].isFull ? phases[1].curExp : phases[0].curExp}',
            style: TextStyle(
              color: AppColors.PRIMARY,
            ),
          ),
          TextSpan(
            text: ' / ${phases[0].isFull ? phases[1].maxExp : phases[0].maxExp}',
          ),
        ],
      ) : phases.length > 0 ? TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: AppColors.PRIMARY_LIGHT,
        ),
        children: [
          TextSpan(
            text: '${phases[0].curExp}',
            style: TextStyle(
              color: AppColors.PRIMARY,
            ),
          ),
          TextSpan(
            text: ' / ${phases[0].maxExp}',
          ),
        ],
      ) : TextSpan(),
      textScaleFactor: 1.0,
    );

    return phases.length == 3 && phases[0].isFull ? Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Center(
          child: phaseScoreText,
        ),
      ),
    ) : phases.length == 3 && !phases[0].isFull ? FractionallySizedBox(
      widthFactor: 0.5,
      child: Center(
        child: phaseScoreText,
      ),
    ) : Center(
      child: phaseScoreText,
    );
  }
}

class _PhaseBar extends StatelessWidget {
  final List<Phase> phases;

  _PhaseBar({
    @required this.phases,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              color: AppColors.BACKGROUND_GREY,
            ),
          ),
          phases.length == 3 ? _ThreePhaseBar(phases)
            : phases.length > 0 ? _SinglePhaseBar(phases[0])
            : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _SinglePhaseBar extends StatelessWidget {
  final Phase phase;

  _SinglePhaseBar(this.phase);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            color: AppColors.PRIMARY_LIGHT,
          ),
        ),
        FractionallySizedBox(
          widthFactor: phase.curExp / phase.maxExp,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              color: AppColors.PRIMARY,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThreePhaseBar extends StatelessWidget {
  final List<Phase> phases;

  _ThreePhaseBar(this.phases);

  @override
  Widget build(BuildContext context) {
    final firstPhase = phases[0];
    final secondPhase = phases[1];
    final isFirstPhaseFull = phases[0].isFull;

    return Stack(
      children: <Widget>[
        isFirstPhaseFull ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            color: AppColors.PRIMARY_LIGHT,
          ),
        ) : FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              color: AppColors.PRIMARY_LIGHT,
            ),
          ),
        ),
        isFirstPhaseFull ? FractionallySizedBox(
          widthFactor: 0.5 + secondPhase.curExp / secondPhase.maxExp * 0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              color: AppColors.PRIMARY,
            ),
          ),
        ) : FractionallySizedBox(
          widthFactor: firstPhase.curExp / firstPhase.maxExp * 0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              color: AppColors.PRIMARY,
            ),
          ),
        ),
      ],
    );
  }
}

class _FAB extends StatelessWidget {
  final FabState state;

  _FAB({
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
          onPressed: () { },
        ),
      ),
    ) : const SizedBox.shrink();
  }
}

class _PetPreview extends StatelessWidget {
  final PetPreview item;

  _PetPreview({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.PRIMARY_LIGHT,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Container(
          color: AppColors.SECONDARY,
        ),
      ),
    );
  }
}
