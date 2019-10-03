
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DateInWeek.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
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
    delegator.showBottomSheet((context) =>
      InputPasswordScreen(onSuccess: () {
        final updatedWeekRecord = weekRecord.buildNew(isCheckPointsLocked: false);
        _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

        _usecases.setCheckPointsLocked(weekRecord.dateInWeek, false);
      }, onFail: () {
        delegator.showSnackBar(Text('잠금 해제에 실패하셨습니다'), duration: Duration(seconds: 2));
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
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '비밀번호 설정',
            style: TextStyle(
              color: AppColors.TEXT_BLACK,
              fontSize: 20,
            ),
          ),
          content: Text(
            '아직 설정된 비밀번호가 없네요!\n비밀번호를 새로 만드시겠어요?',
            style: TextStyle(
              color: AppColors.TEXT_BLACK_LIGHT,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '취소',
                style: TextStyle(
                  color: AppColors.TEXT_BLACK,
                  fontSize: 14,
                ),
              ),
              onPressed: () => _onCreatePasswordCancelClicked(context),
            ),
            FlatButton(
              child: Text(
                '확인',
                style: TextStyle(
                  color: AppColors.PRIMARY,
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

  void onDayPreviewClicked(BuildContext context, DayRecord dayRecord) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayScreen(dayRecord: dayRecord,),
      ),
    );
  }

  void onDayPreviewLockedIconClicked(WeekRecord weekRecord, DayRecord dayRecord) {
    delegator.showBottomSheet((context) =>
      InputPasswordScreen(onSuccess: () {
        final updatedDayRecord = dayRecord.buildNew(isLocked: false);
        final updatedWeekRecord = weekRecord.buildNewDayRecordUpdated(updatedDayRecord);
        _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

        _usecases.setDayRecordLocked(dayRecord.date, false);
      }, onFail: () {
        delegator.showSnackBar(Text('잠금 해제에 실패하셨습니다'), duration: Duration(seconds: 2));
      }),
    );
  }

  Future<void> onDayPreviewUnlockedIconClicked(WeekRecord weekRecord, DayRecord dayRecord, BuildContext context) async {
    final password = await _usecases.getUserPassword();
    if (password.isEmpty) {
      _showCreatePasswordDialog(context);
    } else {
      final updatedDayRecord = dayRecord.buildNew(isLocked: true);
      final updatedWeekRecord = weekRecord.buildNewDayRecordUpdated(updatedDayRecord);
      _state.add(_state.value.buildNewWeekRecordUpdated(updatedWeekRecord));

      _usecases.setDayRecordLocked(dayRecord.date, true);
    }
  }

  void _onCreatePasswordCancelClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onCreatePasswordOkClicked(BuildContext context) {
    Navigator.pop(context);
    delegator.showBottomSheet(
        (context) => CreatePasswordScreen(),
      onClosed: (any) async {
        final isPasswordSaved = await _usecases.getUserPassword().then((s) => s.length == 4);
        if (isPasswordSaved) {
          delegator.showSnackBar(
            Text('비밀번호가 설정되었습니다!'),
            duration: Duration(seconds: 2),
          );
        } else {
          delegator.showSnackBar(
            Text('비밀번호가 설정되지 않았습니다!'),
            duration: Duration(seconds: 2),
          );
        }
      }
    );
  }

  void dispose() {
    _state.close();
  }
}