
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:todo_app/domain/home/record/DayRecord.dart';
import 'package:todo_app/domain/home/record/entity/DayMemo.dart';
import 'package:todo_app/presentation/home/record/RecordActions.dart';
import 'package:todo_app/presentation/home/record/RecordBloc.dart';
import 'package:todo_app/presentation/home/record/RecordState.dart';
import 'package:todo_app/presentation/widgets/DayMemoTextField.dart';
import 'package:todo_app/presentation/widgets/ToDoTextField.dart';
import 'package:todo_app/presentation/widgets/WeekMemoTextField.dart';

class RecordScreen extends StatefulWidget {
  @override
  State createState() {
    return _RecordScreenState();
  }
}

class _RecordScreenState extends State<RecordScreen> {
  RecordBloc _bloc;
  final _daysPageController = InfinityPageController(initialPage: 0, viewportFraction: 0.75);

  @override
  void initState() {
    super.initState();
    _bloc = RecordBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.initialState,
      stream: _bloc.state,
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  Widget _buildUI(RecordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildYearAndMonthNthWeek(state),
        _buildWeekMemos(state),
        _buildDayRecordsPager(state),
      ],
    );
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
      onTap: _onYearAndMonthNthWeekClicked,
    );
  }

  _onYearAndMonthNthWeekClicked() {
    _bloc.actions.add(NavigateToCalendarPage());
  }

  Widget _buildWeekMemos(RecordState state) {
    final weekMemos = state.weekMemoSet.memos;
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: List.generate(weekMemos.length, (index) {
              final textField = WeekMemoTextField(
                text: weekMemos[index],
                onChanged: (changed) => _onWeekMemoTextChanged(changed, index),
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

  _onWeekMemoTextChanged(String changed, int which) {
    _bloc.actions.add(UpdateSingleWeekMemo(changed, which));
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
            if (dayRecords.isEmpty) {
              return null;
            }
            return _buildDayRecord(dayRecords[index]);
          },
          onPageChanged: _onDayRecordsPageChanged,
        ),
      ),
    );
  }

  _onDayRecordsPageChanged(int index) {
    _bloc.actions.add(UpdateDayRecordPageIndex(index));
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
                      itemCount: record.todos.length + 1,
                      itemBuilder: (context, index) {
                        if (index == record.todos.length) {
                          return Center(
                            child: IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {

                              },
                            ),
                          );
                        } else {
                          return ToDoTextField(
                            text: record.todos[index].content,
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
                  text: record.memo.content,
                  onChanged: (s) => _onDayMemoTextChanged(record.memo, s),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onDayMemoTextChanged(DayMemo dayMemo, String changed) {
    _bloc.actions.add(UpdateDayMemo(dayMemo, changed));
  }
}
