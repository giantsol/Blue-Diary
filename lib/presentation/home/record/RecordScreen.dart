
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/presentation/home/record/RecordBloc.dart';
import 'package:todo_app/presentation/home/record/RecordBlocDelegator.dart';
import 'package:todo_app/presentation/home/record/RecordState.dart';
import 'package:todo_app/presentation/home/record/RecordStateV2.dart';
import 'package:todo_app/presentation/widgets/CheckPointTextField.dart';
import 'package:todo_app/presentation/widgets/DayMemoTextField.dart';
import 'package:todo_app/presentation/widgets/ToDoTextField.dart';
import 'package:todo_app/presentation/widgets/WeekMemoTextField.dart';

class RecordScreen extends StatefulWidget {
  final RecordBlocDelegator recordBlocDelegator;

  RecordScreen({
    Key key,
    this.recordBlocDelegator,
  }): super(key: key);

  @override
  State createState() {
    return _RecordScreenState();
  }
}

class _RecordScreenState extends State<RecordScreen> {
  RecordBloc _bloc;
  InfinityPageController _daysPageController;
  final Map<String, FocusNode> _focusNodes = {};

  @override
  initState() {
    super.initState();
    _bloc = RecordBloc(delegator: widget.recordBlocDelegator);
    _daysPageController = InfinityPageController(initialPage: _bloc.getInitialState().dayRecordPageIndex, viewportFraction: 0.75);
  }

  @override
  void didUpdateWidget(RecordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.delegator = widget.recordBlocDelegator;
  }

  @override
  dispose() {
    super.dispose();
    _bloc.dispose();

    _focusNodes.forEach((key, focusNode) => focusNode.dispose());
    _focusNodes.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _buildUIV2(RecordStateV2.createTestState());
//    return StreamBuilder(
//      initialData: _bloc.getInitialState(),
//      stream: _bloc.observeState(),
//      builder: (context, snapshot) {
//      }
//    );
  }

  Widget _buildUIV2(RecordStateV2 state) {
    return WillPopScope(
      onWillPop: () async {
        return !_unfocusTextFieldIfAny();
      },
      child: GestureDetector(
        onTapDown: (_) => _unfocusTextFieldIfAny(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(state),
                  _buildCheckPoints(state),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildHeader(RecordStateV2 state) {
    return Padding(
      padding: const EdgeInsets.only(right: 55),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                state.year,
                style: TextStyle(
                  color: AppColors.textBlack,
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  state.monthAndNthWeek,
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 24,
                  )
                ),
              ),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildCheckPoints(RecordStateV2 state) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 6, right: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 7, top: 3, right: 3, bottom: 3),
          child: Column(
            children: [
              _buildCheckPointsHeader(state),
              state.isCheckPointsLocked ? Container() : _buildCheckPointsList(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckPointsHeader(RecordStateV2 state) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: <Widget>[
          Text(
            'CHECK POINTS',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
            ),
          ),
          Spacer(),
          state.isCheckPointsLocked ? _buildLockedIcon() : _buildUnlockedIcon(),
        ],
      ),
    );
  }

  Widget _buildLockedIcon() {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: Image.asset('assets/ic_lock_on.png'),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {},
            ),
          )
        ]
      ),
    );
  }

  Widget _buildUnlockedIcon() {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                shape: BoxShape.circle,
              ),
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: Image.asset('assets/ic_lock_off.png'),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {},
            ),
          )
        ]
      ),
    );
  }

  Widget _buildCheckPointsList(RecordStateV2 state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        children: List.generate(state.checkPoints.length, (index) {
          return _buildCheckPointItem(state.checkPoints[index]);
        }),
      ),
    );
  }

  Widget _buildCheckPointItem(CheckPoint checkPoint) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 7),
      child: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 20,),
            child: Center(
              child: Text(
                checkPoint.bulletPointNumber.toString(),
                style: TextStyle(
                  color: AppColors.textWhiteDark,
                  fontSize: 16,
                ),
              ),
            )
          ),
          SizedBox(width: 5,),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 30,),
              child: Container(
                alignment: Alignment.center,
                child: CheckPointTextField(
                  text: checkPoint.text,
                  hintText: checkPoint.hintText,
                  onChanged: (s) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUI(RecordState state) {
    return WillPopScope(
      onWillPop: () async {
        return !_unfocusTextFieldIfAny();
      },
      child: GestureDetector(
        onTapDown: (_) => _unfocusTextFieldIfAny(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildYearAndMonthNthWeek(state),
                _buildWeekMemos(state),
                _buildDayRecordsPager(state),
              ],
            ),
            _buildGoToTodayButton(state),
          ]
        ),
      ),
    );
  }

  bool _unfocusTextFieldIfAny() {
    for (FocusNode focusNode in _focusNodes.values) {
      if (focusNode.hasPrimaryFocus) {
        focusNode.unfocus();
        return true;
      }
    }
    return false;
  }

  Widget _buildYearAndMonthNthWeek(RecordState state) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              state.yearText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4,),
            Text(
              state.monthAndNthWeekText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      onTap: () => _bloc.onYearAndMonthNthWeekClicked(),
    );
  }

  Widget _buildWeekMemos(RecordState state) {
    final weekMemos = state.weekMemos;
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: List.generate(weekMemos.length, (index) {
              final weekMemo = weekMemos[index];
              final textField = WeekMemoTextField(
                focusNode: _getOrCreateFocusNode(weekMemo.key),
                text: weekMemo.content,
                onChanged: (changed) => _bloc.onWeekMemoTextChanged(weekMemo, changed),
              );

              if (index == 0) {
                return textField;
              } else {
                return Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: textField,
                );
              }
            }),
          );
        },
      ),
    );
  }

  Widget _buildDayRecordsPager(RecordState state) {
    final dayRecords = state.dayRecords;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: InfinityPageView(
          controller: _daysPageController,
          itemCount: dayRecords.length,
          itemBuilder: (context, index) {
            // 에에~? 왜 dayRecords.length가 0인데도 itemBuilder가 한번 불리징 훔..
            if (dayRecords.isEmpty || dayRecords[index] == null) {
              return null;
            }
            return _buildDayRecord(dayRecords[index]);
          },
          onPageChanged: (changedIndex) => _bloc.onDayRecordsPageChanged(changedIndex),
        ),
      ),
    );
  }

  Widget _buildDayRecord(DayRecord record) {
    return Center(
      child: ClipRect(
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8,),
                Center(
                  child: Text(record.title),
                ),
                SizedBox(
                  height: 228,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6,),
                    child: ListView.builder(
                      itemCount: record.toDos.length + 1,
                      itemBuilder: (context, index) {
                        if (index == record.toDos.length) {
                          return Center(
                            child: IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () => _bloc.onAddToDoClicked(record),
                            ),
                          );
                        } else {
                          final toDo = record.toDos[index];
                          return ToDoTextField(
                            focusNode: _getOrCreateFocusNode(toDo.key),
                            toDo: toDo,
                            onChanged: (s) => _bloc.onToDoTextChanged(record, toDo, s),
                            onCheckBoxClicked: () => _bloc.onToDoCheckBoxClicked(record, toDo),
                            onDismissed: () => _bloc.onToDoDismissed(record, toDo),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.black,),
                Padding(
                  padding: EdgeInsets.only(left: 4, top: 4,),
                  child: Text(
                    'MEMO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DayMemoTextField(
                  focusNode: _getOrCreateFocusNode(record.memo.key),
                  text: record.memo.content,
                  onChanged: (s) => _bloc.onDayMemoTextChanged(record, s),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  FocusNode _getOrCreateFocusNode(String key) {
    if (_focusNodes.containsKey(key)) {
      return _focusNodes[key];
    } else {
      final newFocusNode = FocusNode();
      _focusNodes[key] = newFocusNode;
      return newFocusNode;
    }
  }

  Widget _buildGoToTodayButton(RecordState state) {
    final goToTodayVisibility = state.goToTodayButtonVisibility;
    if (goToTodayVisibility == GoToTodayButtonVisibility.GONE) {
      return Container();
    } else {
      return Center(
        child: Row(
          mainAxisAlignment: goToTodayVisibility == GoToTodayButtonVisibility.LEFT ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => _bloc.onGoToTodayButtonClicked(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(8),
                child: Text('오늘로 이동')
              ),
            ),
          ]
        ),
      );
    }
  }

}
