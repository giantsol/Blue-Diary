
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/usecase/DayUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/day/DayState.dart';

class DayBloc {
  final _state = BehaviorSubject<DayState>.seeded(DayState.createDummy());
  DayState getInitialState() => _state.value;
  Stream<DayState> observeState() => _state.distinct();

  final DayUsecases _usecases = dependencies.dayUsecases;

  DayBloc(DayRecord dayRecord) {
    _initState(dayRecord);
  }

  void _initState(DayRecord dayRecord) {

  }

  void onBackArrowClicked(BuildContext context) {
    Navigator.pop(context);
  }

  void onAddToDoClicked() {

  }

  void onDayMemoCollapseOrExpandClicked() {

  }

  void onDayMemoTextChanged(String changed) {

  }

  void onToDoCheckBoxClicked(ToDo toDo) {

  }

  void dispose() {
    _state.close();
  }
}