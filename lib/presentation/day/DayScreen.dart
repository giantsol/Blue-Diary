
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/presentation/day/DayBloc.dart';
import 'package:todo_app/presentation/day/DayState.dart';
import 'package:todo_app/presentation/widgets/DayMemoTextField.dart';

class DayScreen extends StatefulWidget {
  final DayRecord dayRecord;

  DayScreen({
    Key key,
    this.dayRecord,
  }): super(key: key);

  @override
  State createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DayBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DayBloc(widget.dayRecord);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  Widget _buildUI(DayState state) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Image.asset('assets/ic_plus.png'),
            backgroundColor: AppColors.primary,
            splashColor: AppColors.primaryDark,
            onPressed: () => _bloc.onAddToDoClicked(),
          ),
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildHeader(state),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildDayMemo(state),
                          _buildToDos(state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 키보드 위 ToDo 입력창
              Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DayState state) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/ic_back_arrow.png'),
          ),
          onTap: () => _bloc.onBackArrowClicked(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            state.title,
            style: TextStyle(
              fontSize: 24,
              color: AppColors.textBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayMemo(DayState state) {
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 6, right: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'MEMO',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      child: Image.asset('assets/ic_collapse.png'),
                    ),
                    onTap: () => _bloc.onDayMemoCollapseOrExpandClicked(),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: SizedBox(
                height: 93,
                child: DayMemoTextField(
                  text: state.memoText,
                  hintText: state.memoHint,
                  onChanged: (s) => _bloc.onDayMemoTextChanged(s),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToDos(DayState state) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 18, top: 20),
          child: Text(
            'TODO',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textBlack,
            ),
          ),
        ),

      ],
    );
  }
}
