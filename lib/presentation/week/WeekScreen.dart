
import 'package:flutter/material.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/presentation/week/WeekBloc.dart';
import 'package:todo_app/presentation/week/WeekState.dart';
import 'package:todo_app/presentation/widgets/AppTextField.dart';

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
  ScrollController _scrollController;
  final GlobalKey<_HeaderShadowState> _headerShadowState = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = WeekBloc(delegator: widget.weekBlocDelegator);
    _weekRecordPageController = InfinityPageController(initialPage: _bloc.getInitialState().weekRecordPageIndex);
    _scrollController = ScrollController();
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
    _weekRecordPageController.dispose();
    _scrollController.dispose();

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
    return state.viewState == WeekViewState.WHOLE_LOADING ? _WholeLoadingView()
      : WillPopScope(
      onWillPop: () async {
        return !_unfocusTextFieldIfAny();
      },
      child: Column(
        children: [
          _Header(
            bloc: _bloc,
            displayYear: state.year.toString(),
            displayMonthAndWeek: AppLocalizations.of(context).getMonthAndNthWeek(state.month, state.nthWeek),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                InfinityPageView(
                  controller: _weekRecordPageController,
                  itemCount: state.weekRecords.length,
                  itemBuilder: (context, index) {
                    final weekRecords = state.weekRecords;
                    if (weekRecords.isEmpty || weekRecords[index] == null) {
                      return null;
                    }
                    return _WeekRecord(
                      bloc: _bloc,
                      weekRecord: weekRecords[index],
                      focusNodeProvider: _getOrCreateFocusNode,
                      scrollController: _scrollController,
                    );
                  },
                  onPageChanged: (changedIndex) {
                    _headerShadowState.currentState.updateShadowVisibility(false);
                    _bloc.onWeekRecordPageChanged(changedIndex);
                  },
                ),
                _HeaderShadow(
                  key: _headerShadowState,
                  scrollController: _scrollController,
                ),
              ],
            ),
          ),
        ]
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

class _WholeLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Header extends StatelessWidget {
  final WeekBloc bloc;
  final String displayYear;
  final String displayMonthAndWeek;

  _Header({
    @required this.bloc,
    @required this.displayYear,
    @required this.displayMonthAndWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 55),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                displayYear,
                style: TextStyle(
                  color: AppColors.TEXT_BLACK,
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  displayMonthAndWeek,
                  style: TextStyle(
                    color: AppColors.TEXT_BLACK,
                    fontSize: 24,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        onTap: () => bloc.onHeaderClicked(),
      ),
    );
  }
}

class _WeekRecord extends StatelessWidget {
  final WeekBloc bloc;
  final WeekRecord weekRecord;
  final FocusNode Function(String key) focusNodeProvider;
  final ScrollController scrollController;

  _WeekRecord({
    @required this.bloc,
    @required this.weekRecord,
    @required this.focusNodeProvider,
    @required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          _CheckPointsBox(
            bloc: bloc,
            weekRecord: weekRecord,
            focusNodeProvider: focusNodeProvider,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: List.generate(weekRecord.dayRecords.length, (index) {
                return _DayPreviewItem(
                  bloc: bloc,
                  weekRecord: weekRecord,
                  dayRecord: weekRecord.dayRecords[index]
                );
              })
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckPointsBox extends StatelessWidget {
  final WeekBloc bloc;
  final WeekRecord weekRecord;
  final FocusNode Function(String key) focusNodeProvider;

  _CheckPointsBox({
    @required this.bloc,
    @required this.weekRecord,
    @required this.focusNodeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 6, right: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.PRIMARY,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 7, top: 3, right: 3, bottom: 3),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      'CHECK POINTS',
                      style: TextStyle(
                        color: AppColors.TEXT_WHITE,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    weekRecord.isCheckPointsLocked ? _LockedIcon(
                      onTap: () => bloc.onCheckPointsLockedIconClicked(weekRecord),
                    ) : _UnlockedIcon(
                      onTap: () => bloc.onCheckPointsUnlockedIconClicked(weekRecord, context),
                    ),
                  ],
                ),
              ),
              weekRecord.isCheckPointsLocked ? const SizedBox.shrink()
                : Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Column(
                  children: List.generate(weekRecord.checkPoints.length, (index) {
                    return _CheckPointItem(
                      bloc: bloc,
                      weekRecord: weekRecord,
                      checkPoint: weekRecord.checkPoints[index],
                      focusNodeProvider: focusNodeProvider,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LockedIcon extends StatelessWidget {
  final void Function() onTap;

  _LockedIcon({
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.SECONDARY,
              shape: BoxShape.circle,
            ),
            width: 28,
            height: 28,
            alignment: Alignment.center,
            child: Image.asset('assets/ic_lock_on.png'),
          ),
        ),
      ),
    );
  }
}

class _UnlockedIcon extends StatelessWidget {
  final void Function() onTap;

  _UnlockedIcon({
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.BACKGROUND_GREY,
              shape: BoxShape.circle,
            ),
            width: 28,
            height: 28,
            alignment: Alignment.center,
            child: Image.asset('assets/ic_lock_off.png'),
          ),
        ),
      ),
    );
  }
}

class _CheckPointItem extends StatelessWidget {
  final WeekBloc bloc;
  final WeekRecord weekRecord;
  final CheckPoint checkPoint;
  final FocusNode Function(String key) focusNodeProvider;

  _CheckPointItem({
    @required this.bloc,
    @required this.weekRecord,
    @required this.checkPoint,
    @required this.focusNodeProvider,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.TEXT_WHITE_DARK,
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
                child: AppTextField(
                  focusNode: focusNodeProvider(checkPoint.key),
                  text: checkPoint.text,
                  textSize: 12,
                  textColor: AppColors.TEXT_WHITE,
                  hintText: checkPoint.hint,
                  hintTextSize: 12,
                  hintColor: AppColors.TEXT_WHITE_DARK,
                  onChanged: (s) => bloc.onCheckPointTextChanged(weekRecord, checkPoint, s),
                  maxLines: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPreviewItem extends StatelessWidget {
  final WeekBloc bloc;
  final WeekRecord weekRecord;
  final DayRecord dayRecord;

  _DayPreviewItem({
    @required this.bloc,
    @required this.weekRecord,
    @required this.dayRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DayPreviewItemContent(
          bloc: bloc,
          weekRecord: weekRecord,
          dayRecord: dayRecord,
        ),
        dayRecord.hasTrailingDots ? _DayPreviewItemTrailingDots(
          filledRatio: dayRecord.filledRatio,
        ) : const SizedBox.shrink(),
      ],
    );
  }
}

// all day preview content from Mon ~ lock icon
class _DayPreviewItemContent extends StatelessWidget {
  final WeekBloc bloc;
  final WeekRecord weekRecord;
  final DayRecord dayRecord;

  _DayPreviewItemContent({
    @required this.bloc,
    @required this.weekRecord,
    @required this.dayRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () => bloc.onDayPreviewClicked(context, dayRecord),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  _DayPreviewItemThumbnail(
                    hasBorder: dayRecord.hasBorder,
                    filledRatio: dayRecord.filledRatio,
                    text: dayRecord.thumbnailString,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, top: 4, bottom: 4,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              dayRecord.isToday == true ? _DayPreviewItemTodayText() : const SizedBox.shrink(),
                              Text(
                                AppLocalizations.of(context).getDayRecordTitle(dayRecord.month, dayRecord.day),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.TEXT_BLACK,
                                ),
                              ),
                              SizedBox(width: 12),
                              dayRecord.filledRatio == 1.0 ? _DayPreviewItemCompleteText() : const SizedBox.shrink(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2,),
                            child: Text(
                              dayRecord.subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: dayRecord.subtitleColor,
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 9),
          child: dayRecord.isLocked ? _LockedIcon(
            onTap: () => bloc.onDayPreviewLockedIconClicked(weekRecord, dayRecord),
          ) : _UnlockedIcon(
            onTap: () => bloc.onDayPreviewUnlockedIconClicked(weekRecord, dayRecord, context),
          ),
        ),
      ],
    );
  }
}

class _DayPreviewItemThumbnail extends StatelessWidget {
  final bool hasBorder;
  final double filledRatio;
  final String text;

  _DayPreviewItemThumbnail({
    @required this.hasBorder,
    @required this.filledRatio,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.BACKGROUND_GREY,
                shape: BoxShape.circle,
                border: hasBorder ? Border.all(
                  color: AppColors.PRIMARY,
                  width: 2,
                ) : null,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: filledRatio,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY,
                    shape: BoxShape.circle,
                  ),
                  child: Container(),
                ),
              )
            ),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.TEXT_WHITE,
                fontSize: 18,
              ),
              textScaleFactor: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPreviewItemTodayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4,),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.SECONDARY,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3,),
        child: Text(
          'TODAY',
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}

class _DayPreviewItemCompleteText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        'COMPLETE',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          color: AppColors.TERTIARY,
        )
      )
    );
  }
}

class _DayPreviewItemTrailingDots extends StatelessWidget {
  final double filledRatio;

  _DayPreviewItemTrailingDots({
    @required this.filledRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 37),
      child: SizedBox(
        width: 4,
        height: 16,
        child: Stack(
          children: [
            _TrailingDots(
              color: AppColors.BACKGROUND_GREY,
              filledRatio: 1.0,
            ),
            _TrailingDots(
              color: AppColors.PRIMARY,
              filledRatio: filledRatio,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrailingDots extends StatelessWidget {
  final Color color;
  final double filledRatio;

  _TrailingDots({
    @required this.color,
    @required this.filledRatio,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _HeaderShadow extends StatefulWidget {
  final ScrollController scrollController;

  _HeaderShadow({
    Key key,
    @required this.scrollController,
  }): super(key: key);

  @override
  State createState() => _HeaderShadowState();
}

class _HeaderShadowState extends State<_HeaderShadow> {
  bool _isShadowVisible = false;
  var _scrollListener;

  @override
  void initState() {
    super.initState();
    _scrollListener = () {
      try {
        updateShadowVisibility(widget.scrollController.position.pixels > 0);
      } catch (e) {
        updateShadowVisibility(false);
      }
    };
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_scrollListener);
  }

  void updateShadowVisibility(bool visible) {
    setState(() {
      _isShadowVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _isShadowVisible ? 6 : 0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.DIVIDER, AppColors.DIVIDER.withAlpha(0)]
        )
      ),
    );
  }
}