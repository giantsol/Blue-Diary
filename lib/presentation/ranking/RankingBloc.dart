
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/presentation/ranking/RankingState.dart';

class RankingBloc {
  final _state = BehaviorSubject<RankingState>.seeded(RankingState());
  RankingState getInitialState() => _state.value;
  Stream<RankingState> observeState() => _state.distinct();

  RankingBloc() {
    _initState();
  }

  void _initState() {

  }

  void dispose() {

  }
}