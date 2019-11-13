
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/usecase/RankingUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/ranking/RankingState.dart';

class RankingBloc {
  final _state = BehaviorSubject<RankingState>.seeded(RankingState());
  RankingState getInitialState() => _state.value;
  Stream<RankingState> observeState() => _state.distinct();

  final RankingUsecases _usecases = dependencies.rankingUsecases;

  RankingBloc() {
    _initState();
  }

  Future<void> _initState() async {
    final userDisplayName = await _usecases.getUserDisplayName();
    _state.add(_state.value.buildNew(
      userDisplayName: userDisplayName,
    ));
  }

  Future<void> onGoogleSignInClicked() async {
    final success = await _usecases.signInWithGoogle();
    if (success) {
      final userDisplayName = await _usecases.getUserDisplayName();
      _state.add(_state.value.buildNew(
        userDisplayName: userDisplayName,
      ));
    }
  }

  Future<void> onSignOutClicked() async {
    final success = await _usecases.signOut();
    if (success) {
      final userDisplayName = await _usecases.getUserDisplayName();
      _state.add(_state.value.buildNew(
        userDisplayName: userDisplayName,
      ));
    }
  }

  void dispose() {

  }
}