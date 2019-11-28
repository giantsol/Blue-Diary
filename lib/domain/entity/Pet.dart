
import 'package:flutter/material.dart';
import 'package:todo_app/data/AppDatabase.dart';

class Pet {
  static const KEY_A = 'a';
  static const KEY_B = 'b';

  static const PHASE_INDEX_INACTIVE = -2;
  static const PHASE_INDEX_EGG = -1;

  static const INVALID = const Pet();

  final String key;
  final PetPhase inactivePhase;
  final PetPhase eggPhase;
  final List<PetPhase> bornPhases; // must be either length 2 or 3
  final int exp;
  final int currentPhaseIndex;

  PetPhase get currentPhase => currentPhaseIndex == PHASE_INDEX_INACTIVE ? inactivePhase
    : currentPhaseIndex == PHASE_INDEX_EGG ? eggPhase
    : bornPhases[currentPhaseIndex];

  int get maxSelectablePhaseIndex {
    final expAfterBorn = exp - eggPhase.maxExp;
    if (expAfterBorn < 0) {
      return currentPhaseIndex;
    } else {
      if (bornPhases.length == 3) {
        if (expAfterBorn < bornPhases[0].maxExp) {
          return 0;
        } else if (expAfterBorn < bornPhases[0].maxExp + bornPhases[1].maxExp) {
          return 1;
        } else {
          return 2;
        }
      } else {
        if (expAfterBorn < bornPhases[0].maxExp) {
          return 0;
        } else {
          return 1;
        }
      }
    }
  }

  bool get hasReachedFullLevel {
    if (currentPhaseIndex < 0) {
      return false;
    } else {
      return exp == eggPhase.maxExp + bornPhases.fold<int>(0, (acc, phase) => acc + phase.maxExp);
    }
  }

  const Pet({
    this.key = '',
    this.inactivePhase = PetPhase.INVALID,
    this.eggPhase = PetPhase.INVALID,
    this.bornPhases = const [],
    this.exp = 0,
    this.currentPhaseIndex = PHASE_INDEX_INACTIVE,
  });

  Pet buildNew({
    int exp,
    int currentPhaseIndex,
  }) {
    return Pet(
      key: this.key,
      inactivePhase: this.inactivePhase,
      eggPhase: this.eggPhase,
      bornPhases: this.bornPhases,
      exp: exp ?? this.exp,
      currentPhaseIndex: currentPhaseIndex ?? this.currentPhaseIndex,
    );
  }

  Pet buildNewExpIncreased() {
    final increasedExp = exp + 1;
    bool increasePhaseIndex = (currentPhaseIndex == Pet.PHASE_INDEX_EGG && increasedExp == eggPhase.maxExp)
      || (currentPhaseIndex == 0 && increasedExp == eggPhase.maxExp + bornPhases[0].maxExp)
      || (bornPhases.length == 3 && currentPhaseIndex == 1 && increasedExp == eggPhase.maxExp + bornPhases[0].maxExp + bornPhases[1].maxExp);
    return buildNew(
      exp: increasedExp,
      currentPhaseIndex: increasePhaseIndex ? currentPhaseIndex + 1 : currentPhaseIndex,
    );
  }

  Map<String, dynamic> toUserDatumDatabase() {
    return {
      AppDatabase.COLUMN_KEY: key,
      AppDatabase.COLUMN_EXP: exp,
      AppDatabase.COLUMN_SELECTED_PHASE: currentPhaseIndex,
    };
  }
}

class PetPhase {
  static const INVALID = const PetPhase();

  final String flrPath;
  final String imgPath;
  final double sizeRatio; // between 0 ~ 1.0
  final Alignment alignment; // how to align flr/img
  final int maxExp;
  final String titleKey; // key in AppLocalizations
  final String subtitleKey; // key in AppLocalizations
  final String idleAnimName;

  const PetPhase({
    this.flrPath = '',
    this.imgPath = '',
    this.sizeRatio = 1.0,
    this.alignment = Alignment.center,
    this.maxExp = 0,
    this.titleKey = '',
    this.subtitleKey = '',
    this.idleAnimName = 'idle',
  });
}
