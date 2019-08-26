
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/RecordUsecases.dart';
import 'package:todo_app/domain/home/record/WeekMemoSet.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/record/RecordActions.dart';
import 'package:todo_app/presentation/home/record/RecordState.dart';

class RecordBloc {
  final _actions = StreamController<RecordAction>();
  Sink get actions => _actions;

  final _state = BehaviorSubject<RecordState>.seeded(RecordState());
  RecordState get initialState => _state.value;
  Stream<RecordState> get state => _state.stream.distinct();

  final RecordUsecases _usecases = dependencies.recordUsecases;

  StreamSubscription<WeekMemoSet> _weekMemoSetSubscription;
  StreamSubscription<List<DayRecord>> _dayRecordsSubscription;

  RecordBloc() {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case UpdateSingleWeekMemo:
          _updateSingleWeekMemo(action);
          break;
        case UpdateDayRecords:
          _updateDayRecords(action);
          break;
        default:
          throw Exception('HomeBloc action not implemented: $action');
      }
    });

    _weekMemoSetSubscription = _usecases.weekMemoSet.listen((set) {
      _state.add(_state.value.getModified(weekMemoSet: set));
    });
    _dayRecordsSubscription = _usecases.days.listen((days) {
      _state.add(_state.value.getModified(days: days));
    });
  }

  _updateSingleWeekMemo(UpdateSingleWeekMemo action) {
    _usecases.updateSingleWeekMemo(action.updatedText, action.index);
  }

  _updateDayRecords(UpdateDayRecords action) {
    _usecases.updateDayRecords(action.focusedIndex);
  }

  dispose() {
    _actions.close();
    _state.close();

    _weekMemoSetSubscription?.cancel();
    _dayRecordsSubscription?.cancel();
  }
}