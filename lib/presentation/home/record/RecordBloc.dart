
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/home/record/RecordUsecases.dart';
import 'package:todo_app/domain/home/record/entity/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/WeekMemo.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/home/record/RecordActions.dart';
import 'package:todo_app/presentation/home/record/RecordState.dart';
import 'package:tuple/tuple.dart';

class RecordBloc {
  final _actions = StreamController<RecordAction>();
  Sink get actions => _actions;

  final _state = BehaviorSubject<RecordState>.seeded(RecordState());
  RecordState get initialState => _state.value;
  Stream<RecordState> get state => _state.stream.distinct();

  final RecordUsecases _usecases = dependencies.recordUsecases;

  StreamSubscription<List<WeekMemo>> _weekMemosSubscription;
  StreamSubscription<List<DayRecord>> _dayRecordsSubscription;
  StreamSubscription<int> _currentYearSubscription;
  StreamSubscription<Tuple2<int, int>> _currentWeeklySeparatedMonthAndNthWeekSubscription;

  RecordBloc() {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case UpdateSingleWeekMemo:
          _updateSingleWeekMemo(action);
          break;
        case UpdateDayRecordPageIndex:
          _updateDayRecordPageIndex(action);
          break;
        case NavigateToCalendarPage:
          _navigateToCalendarPage(action);
          break;
        case UpdateDayMemo:
          _updateDayMemo(action);
          break;
        case AddToDo:
          _addToDo(action);
          break;
        case UpdateToDoContent:
          _updateToDoContent(action);
          break;
        case UpdateToDoDone:
          _updateToDoDone(action);
          break;
        case RemoveToDo:
          _removeToDo(action);
          break;
        case GoToToday:
          _goToToday(action);
          break;
        default:
          throw Exception('HomeBloc action not implemented: $action');
      }
    });

    _weekMemosSubscription = _usecases.weekMemos.listen((memos) {
      _state.add(_state.value.getModified(weekMemos: memos));
    });
    _dayRecordsSubscription = _usecases.dayRecords.listen((days) {
      final today = _usecases.today;
      final selectedDay = days.firstWhere((record) => record.isSelected, orElse: () => null)?.dateTime;
      if (selectedDay == null) {
        _state.add(_state.value.getModified(days: days));
      } else {
        final dayDifference = today.difference(selectedDay).inDays;
        bool isGoToTodayButtonShown = dayDifference.abs() >= 2;
        bool isGoToTodayButtonShownLeft = dayDifference < 0;
        _state.add(_state.value.getModified(days: days,
          isGoToTodayButtonShown: isGoToTodayButtonShown,
          isGoToTodayButtonShownLeft: isGoToTodayButtonShownLeft,
        ));
      }
    });
    _currentYearSubscription = _usecases.currentYear.listen((year) {
      _state.add(_state.value.getModified(year: year));
    });
    _currentWeeklySeparatedMonthAndNthWeekSubscription = _usecases.currentWeeklySeparatedMonthAndNthWeek.listen((tuple) {
      _state.add(_state.value.getModified(weeklySeparatedMonthAndNthWeek: tuple));
    });
  }

  _updateSingleWeekMemo(UpdateSingleWeekMemo action) {
    _usecases.updateSingleWeekMemo(action.weekMemo, action.updated);
  }

  _updateDayRecordPageIndex(UpdateDayRecordPageIndex action) {
    _usecases.updateDayRecordPageIndex(action.updatedIndex);
  }

  _navigateToCalendarPage(NavigateToCalendarPage action) {
    _usecases.navigateToCalendarPage();
  }

  _updateDayMemo(UpdateDayMemo action) {
    _usecases.updateDayMemo(action.dayMemo, action.updated);
  }

  _addToDo(AddToDo action) {
    _usecases.addToDo(action.dayRecord);
  }

  _updateToDoContent(UpdateToDoContent action) {
    _usecases.updateToDoContent(action.dayRecord, action.toDo, action.updated);
  }

  _updateToDoDone(UpdateToDoDone action) {
    _usecases.updateToDoDone(action.dayRecord, action.toDo);
  }

  _removeToDo(RemoveToDo action) {
    _usecases.removeToDo(action.dayRecord, action.toDo);
  }

  _goToToday(GoToToday action) {
    _usecases.goToToday();
  }

  dispose() {
    _actions.close();
    _state.close();

    _weekMemosSubscription?.cancel();
    _dayRecordsSubscription?.cancel();
    _currentYearSubscription?.cancel();
    _currentWeeklySeparatedMonthAndNthWeekSubscription?.cancel();
  }
}