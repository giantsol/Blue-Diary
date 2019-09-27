
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/domain/usecase/WeekUsecases.dart';
import 'package:todo_app/presentation/App.dart';
import 'package:todo_app/presentation/createpassword/CreatePasswordScreen.dart';
import 'package:todo_app/presentation/week/WeekBlocDelegator.dart';
import 'package:todo_app/presentation/week/WeekState.dart';

class WeekBloc {
  WeekBlocDelegator delegator;

  final _state = BehaviorSubject<WeekState>.seeded(WeekState());
  WeekState getInitialState() => _state.value;
  Stream<WeekState> observeState() => _state.distinct();

  final WeekUsecases _usecases = dependencies.weekUsecases;

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
      year: dateInWeek.year.toString(),
      monthAndWeek: dateInWeek.monthAndNthWeekText,
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

  void onHeaderClicked() {
    _usecases.setCurrentDateToToday();
    _initState();
  }

  void onCheckPointsLockedIconClicked(WeekRecord weekRecord) {
    final updatedWeekRecord = weekRecord.buildNew(isCheckPointsLocked: false);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setCheckPointsLocked(weekRecord.dateInWeek, false);
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
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '비밀번호 설정',
            style: TextStyle(
              color: AppColors.textBlack,
              fontSize: 20,
            ),
          ),
          content: Text(
            '아직 설정된 비밀번호가 없네요!\n비밀번호를 새로 만드시겠어요?',
            style: TextStyle(
              color: AppColors.textBlackLight,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '취소',
                style: TextStyle(
                  color: AppColors.textBlack,
                  fontSize: 14,
                ),
              ),
              onPressed: () => _onCreatePasswordCancelClicked(context),
            ),
            FlatButton(
              child: Text(
                '확인',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
              onPressed: () => _onCreatePasswordOkClicked(context),
            )
          ],
        );
      },
    );
  }


  void onCheckPointTextChanged(WeekRecord weekRecord, CheckPoint checkPoint, String changed) {
    final updatedCheckPoint = checkPoint.buildNew(text: changed);
    final updatedWeekRecord = weekRecord.buildNewCheckPointUpdated(updatedCheckPoint);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setCheckPoint(checkPoint);
  }

  void onDayPreviewClicked(DayPreview dayPreview) {

  }

  void onDayPreviewLockedIconClicked(WeekRecord weekRecord, DayPreview dayPreview) {
    final updatedDayPreview = dayPreview.buildNew(isLocked: false);
    final updatedWeekRecord = weekRecord.buildNewDayPreviewUpdated(updatedDayPreview);
    _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

    _usecases.setDayRecordLocked(dayPreview.date, false);
  }

  Future<void> onDayPreviewUnlockedIconClicked(WeekRecord weekRecord, DayPreview dayPreview, BuildContext context) async {
    final password = await _usecases.getUserPassword();
    if (password.isEmpty) {
      _showCreatePasswordDialog(context);
    } else {
      final updatedDayPreview = dayPreview.buildNew(isLocked: true);
      final updatedWeekRecord = weekRecord.buildNewDayPreviewUpdated(updatedDayPreview);
      _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

      _usecases.setDayRecordLocked(dayPreview.date, true);
    }
  }

  void _onCreatePasswordCancelClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onCreatePasswordOkClicked(BuildContext context) {
    Navigator.pop(context);
    delegator.showBottomSheet(
        (context) => CreatePasswordScreen(),
        (any) {
        debugPrint('CreatePassword closed');
      });
  }

  void dispose() {
    _state.close();
  }
}