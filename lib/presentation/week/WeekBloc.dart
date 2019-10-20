
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/usecase/WeekUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordScreen.dart';
import 'package:todo_app/presentation/day/DayScreen.dart';
import 'package:todo_app/presentation/inputpassword/InputPasswordScreen.dart';
import 'package:todo_app/presentation/week/WeekState.dart';

class WeekBloc {
  WeekBlocDelegator delegator;

  final _state = BehaviorSubject<WeekState>.seeded(WeekState());
  WeekState getInitialState() => _state.value;
  Stream<WeekState> observeState() => _state.distinct();

  final WeekUsecases _usecases = dependencies.weekUsecases;

  final _snackBarDuration = const Duration(seconds: 2);

  WeekBloc({this.delegator}) {
    _initState();
  }

  Future<void> _initState({int weekRecordPageIndex}) async {
    final dateInWeek = DateInWeek.fromDate(_usecases.getCurrentDate());
    final currentWeekRecordPageIndex = weekRecordPageIndex ?? _state.value.weekRecordPageIndex;
    final currentWeekRecord = await _usecases.getCurrentWeekRecord();
    final prevWeekRecord = await _usecases.getPrevWeekRecord();
    final nextWeekRecord = await _usecases.getNextWeekRecord();
    var weekRecords;
    if (currentWeekRecordPageIndex == 0) {
      weekRecords = [currentWeekRecord, nextWeekRecord, prevWeekRecord];
    } else if (currentWeekRecordPageIndex == 1) {
      weekRecords = [prevWeekRecord, currentWeekRecord, nextWeekRecord];
    } else {
      weekRecords = [nextWeekRecord, prevWeekRecord, currentWeekRecord];
    }

    _state.add(_state.value.buildNew(
      viewState: WeekViewState.NORMAL,
      year: dateInWeek.year,
      month: dateInWeek.month,
      nthWeek: dateInWeek.nthWeek,
      weekRecords: weekRecords,
      weekRecordPageIndex: currentWeekRecordPageIndex,
    ));
  }

  void onWeekRecordPageChanged(int newIndex) {
    final curIndex = _state.value.weekRecordPageIndex;
    if ((curIndex == 0 && newIndex == 1)
      || (curIndex == 1 && newIndex == 2)
      || (curIndex == 2 && newIndex == 0)) {
      _usecases.setCurrentDateToNextWeek();
    } else {
      _usecases.setCurrentDateToPrevWeek();
    }
    _initState(weekRecordPageIndex: newIndex);
  }

  void onCheckPointsLockedIconClicked(WeekRecord weekRecord) {
    delegator.showBottomSheet((context) =>
      InputPasswordScreen(onSuccess: () {
        final updatedWeekRecord = weekRecord.buildNew(isCheckPointsLocked: false);
        _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));
        _usecases.setCheckPointsLocked(weekRecord.dateInWeek, false);
      }, onFail: () {
        delegator.showSnackBar(AppLocalizations.of(context).unlockFail, _snackBarDuration);
      }),
    );
  }

  Future<void> onCheckPointsUnlockedIconClicked(WeekRecord weekRecord, BuildContext context) async {
    final password = await _usecases.getUserPassword();
    if (password.isEmpty) {
      _showCreatePasswordDialog(context);
    } else {
      final updatedWeekRecord = weekRecord.buildNew(isCheckPointsLocked: true);
      _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

      _usecases.setCheckPointsLocked(weekRecord.dateInWeek, true);
    }
  }

  Future<void> _showCreatePasswordDialog(BuildContext context) async {
    return Utils.showAppDialog<void>(context,
      AppLocalizations.of(context).createPassword,
      AppLocalizations.of(context).createPasswordBody,
        null,
        () => _onCreatePasswordOkClicked(context));
  }

  void onCheckPointTextChanged(WeekRecord weekRecord, CheckPoint checkPoint, String changed) {
    final updatedCheckPoint = checkPoint.buildNew(text: changed);
    final updatedWeekRecord = weekRecord.buildNewCheckPointUpdated(updatedCheckPoint);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setCheckPoint(checkPoint);
  }

  Future<void> onDayPreviewClicked(BuildContext context, DayPreview dayPreview) async {
    if (dayPreview.isLocked) {
      delegator.showBottomSheet((context) =>
        InputPasswordScreen(onSuccess: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DayScreen(dayPreview.date),
            ),
          );
          _initState();
        }, onFail: () {
          delegator.showSnackBar(AppLocalizations.of(context).unlockFail, _snackBarDuration);
        }),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DayScreen(dayPreview.date),
        ),
      );
      _initState();
    }
  }

  void onDayPreviewLockedIconClicked(WeekRecord weekRecord, DayPreview dayPreview) {
    delegator.showBottomSheet((context) =>
      InputPasswordScreen(onSuccess: () {
        final updatedDayPreview = dayPreview.buildNew(isLocked: false);
        final updatedWeekRecord = weekRecord.buildNewDayPreviewUpdated(updatedDayPreview);
        _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

        final date = DateTime(dayPreview.year, dayPreview.month, dayPreview.day);
        _usecases.setDayRecordLocked(date, false);
      }, onFail: () {
        delegator.showSnackBar(AppLocalizations.of(context).unlockFail, _snackBarDuration);
      }),
    );
  }

  Future<void> onDayPreviewUnlockedIconClicked(WeekRecord weekRecord, DayPreview dayPreview, BuildContext context) async {
    final password = await _usecases.getUserPassword();
    if (password.isEmpty) {
      _showCreatePasswordDialog(context);
    } else {
      final updatedDayPreview = dayPreview.buildNew(isLocked: true);
      final updatedWeekRecord = weekRecord.buildNewDayPreviewUpdated(updatedDayPreview);
      _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

      final date = DateTime(dayPreview.year, dayPreview.month, dayPreview.day);
      _usecases.setDayRecordLocked(date, true);
    }
  }

  void _onCreatePasswordOkClicked(BuildContext context) {
    final successMsg = AppLocalizations.of(context).createPasswordSuccess;
    final failMsg = AppLocalizations.of(context).createPasswordFail;
    delegator.showBottomSheet((context) => CreatePasswordScreen(),
      onClosed: () async {
        final isPasswordSaved = await _usecases.getUserPassword().then((s) => s.length == 4);
        if (isPasswordSaved) {
          delegator.showSnackBar(successMsg, _snackBarDuration);
        } else {
          delegator.showSnackBar(failMsg, _snackBarDuration);
        }
      }
    );
  }

  void dispose() {
    _state.close();
  }
}