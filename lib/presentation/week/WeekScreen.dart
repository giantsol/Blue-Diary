
import 'package:flutter/material.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/presentation/week/WeekBloc.dart';
import 'package:todo_app/presentation/week/WeekBlocDelegator.dart';
import 'package:todo_app/presentation/week/WeekState.dart';
import 'package:todo_app/presentation/widgets/CheckPointTextField.dart';

class WeekScreen extends StatefulWidget {
  final WeekBlocDelegator weekBlocDelegator;

  WeekScreen({
    Key key,
    this.weekBlocDelegator,
  }): super(key: key);

  @override
  State createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  WeekBloc _bloc;
  InfinityPageController _weekRecordPageController;
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    _bloc = WeekBloc(delegator: widget.weekBlocDelegator);
    _weekRecordPageController = InfinityPageController(initialPage: _bloc.getInitialState().weekRecordPageIndex);
  }

  @override
  void didUpdateWidget(WeekScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.delegator = widget.weekBlocDelegator;
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();

    _focusNodes.forEach((key, focusNode) => focusNode.dispose());
    _focusNodes.clear();
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

  Widget _buildUI(WeekState state) {
    return WillPopScope(
      onWillPop: () async {
        return !_unfocusTextFieldIfAny();
      },
      child: GestureDetector(
        onTapDown: (_) => _unfocusTextFieldIfAny(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            _buildHeader(state),
            Expanded(
              child: InfinityPageView(
                controller: _weekRecordPageController,
                itemCount: state.weekRecords.length,
                itemBuilder: (context, index) {
                  final weekRecords = state.weekRecords;
                  if (weekRecords.isEmpty || weekRecords[index] == null) {
                    return null;
                  }
                  return _buildWeekRecord(weekRecords[index]);
                },
                onPageChanged: (changedIndex) => _bloc.onWeekRecordPageChanged(changedIndex),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildHeader(WeekState state) {
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
                  state.monthAndWeek,
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 24,
                  )
                ),
              ),
            ],
          ),
        ),
        onTap: () => _bloc.onHeaderClicked(),
      ),
    );
  }

  Widget _buildWeekRecord(WeekRecord weekRecord) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCheckPoints(weekRecord),
          _buildDayPreviews(weekRecord),
        ],
      ),
    );
  }

  Widget _buildCheckPoints(WeekRecord weekRecord) {
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
              _buildCheckPointsHeader(weekRecord),
              weekRecord.isCheckPointsLocked ? Container() : _buildCheckPointsList(weekRecord),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckPointsHeader(WeekRecord weekRecord) {
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
          weekRecord.isCheckPointsLocked ? _buildLockedIcon(
            onTap: () => _bloc.onCheckPointsLockedIconClicked(weekRecord),
          ) : _buildUnlockedIcon(
            onTap: () => _bloc.onCheckPointsUnlockedIconClicked(weekRecord),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedIcon({Function onTap}) {
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
              onTap: onTap,
            ),
          )
        ]
      ),
    );
  }

  Widget _buildUnlockedIcon({Function onTap}) {
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
              onTap: onTap,
            ),
          )
        ]
      ),
    );
  }

  Widget _buildCheckPointsList(WeekRecord weekRecord) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        children: List.generate(weekRecord.checkPoints.length, (index) {
          return _buildCheckPointItem(weekRecord, weekRecord.checkPoints[index]);
        }),
      ),
    );
  }

  Widget _buildCheckPointItem(WeekRecord weekRecord, CheckPoint checkPoint) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 7),
      child: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 20,),
            child: Center(
              child: Text(
                (checkPoint.index + 1).toString(),
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
                  focusNode: _getOrCreateFocusNode(checkPoint.key),
                  text: checkPoint.text,
                  hintText: checkPoint.hint,
                  onChanged: (s) => _bloc.onCheckPointTextChanged(weekRecord, checkPoint, s),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayPreviews(WeekRecord weekRecord) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: List.generate(weekRecord.dayPreviews.length, (index) {
          return _buildDayPreviewItem(weekRecord, weekRecord.dayPreviews[index]);
        })
      ),
    );
  }

  Widget _buildDayPreviewItem(WeekRecord weekRecord, DayPreview dayPreview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDayPreviewItemContent(weekRecord, dayPreview),
        dayPreview.hasTrailingDots ? _buildDayPreviewItemTrailingDots(dayPreview.filledRatio) : Container(),
      ],
    );
  }

  // all day preview content from Mon ~ lock icon
  Widget _buildDayPreviewItemContent(WeekRecord weekRecord, DayPreview dayPreview) {
    return Row(
      children: <Widget>[
        Expanded(
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundGrey,
                                  shape: BoxShape.circle,
                                  border: dayPreview.hasBorder
                                    ? Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  )
                                    : null,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: dayPreview.filledRatio,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(),
                                  ),
                                )
                              ),
                            ),
                            Center(
                              child: Text(
                                dayPreview.thumbnailString,
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 18,
                                ),
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, top: 4, bottom: 4,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  dayPreview.isToday == true
                                    ? Padding(
                                    padding: EdgeInsets.only(right: 4,),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3,),
                                      child: Text(
                                        'TODAY',
                                        style: TextStyle(
                                          color: AppColors.textWhite,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                                  )
                                    : Container(),
                                  Text(
                                    dayPreview.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  dayPreview.filledRatio == 1.0
                                    ? Expanded(
                                    child: Text(
                                      'COMPLETE',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.tertiary,
                                      )
                                    )
                                  )
                                    : Container(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2,),
                                child: Text(
                                  dayPreview.subtitle,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: dayPreview.subtitleColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => _bloc.onDayPreviewClicked(dayPreview),
                  ),
                ),
              ]
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 9),
          child: dayPreview.isLocked ? _buildLockedIcon(
            onTap: () => _bloc.onDayPreviewLockedIconClicked(weekRecord, dayPreview),
          ) : _buildUnlockedIcon(
            onTap: () => _bloc.onDayPreviewUnlockedIconClicked(weekRecord, dayPreview),
          ),
        ),
      ],
    );
  }

  // trailing dots below DayPreviewItemContent
  Widget _buildDayPreviewItemTrailingDots(double filledRatio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 37),
      child: SizedBox(
        width: 4,
        height: 16,
        child: Stack(
          children: [
            _buildTrailingDots(AppColors.backgroundGrey, 1.0),
            _buildTrailingDots(AppColors.primary, filledRatio),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingDots(Color color, double filledRatio) {
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: filledRatio,
        child: Column(
          children: <Widget>[
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 2,),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 2,),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ],
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

  bool _unfocusTextFieldIfAny() {
    for (FocusNode focusNode in _focusNodes.values) {
      if (focusNode.hasPrimaryFocus) {
        focusNode.unfocus();
        return true;
      }
    }
    return false;
  }

}
