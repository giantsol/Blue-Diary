
import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/presentation/week/WeekBloc.dart';
import 'package:todo_app/presentation/week/WeekScreenTutorialCallback.dart';
import 'package:todo_app/presentation/week/WeekState.dart';
import 'package:todo_app/presentation/widgets/AppTextField.dart';

class WeekScreen extends StatefulWidget {
  static const MAX_WEEK_PAGE = 100;
  static const INITIAL_WEEK_PAGE = 50;

  final WeekBlocDelegator weekBlocDelegator;

  WeekScreen({
    this.weekBlocDelegator,
  });

  @override
  State createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> implements WeekScreenTutorialCallback {
  WeekBloc _bloc;
  PageController _pageController;
  final Map<String, FocusNode> _focusNodes = {};
  ScrollController _scrollController;
  final GlobalKey<_HeaderShadowState> _headerShadowKey = GlobalKey();
  final GlobalKey _firstWeekRecordKey = GlobalKey();

  // variables related with tutorial
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _firstCheckPointsKey = GlobalKey();
  final GlobalKey _todayPreviewKey = GlobalKey();
  final GlobalKey _firstCompletableWeekRecord = GlobalKey();
  final GlobalKey _firstCompletableDayPreview = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = WeekBloc(delegator: widget.weekBlocDelegator);
    _pageController = PageController(initialPage: _bloc.getInitialState().initialWeekRecordPageIndex);
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(WeekScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.updateDelegator(widget.weekBlocDelegator);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _pageController.dispose();
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
    if (state.moveToTodayEvent) {
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_bloc.getInitialState().initialWeekRecordPageIndex);
        }
      });
    }

    if (state.animateToPageEvent != -1) {
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(state.animateToPageEvent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        }
      });
    }

    if (state.startTutorialEvent) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _checkViewsBuiltToStartTutorial());
    }

    if (state.scrollToTodayPreviewEvent) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToTodayPreview());
    }

    if (state.showFirstCompletableDayTutorialEvent) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _checkViewsBuiltToShowFirstCompletableDayTutorial());
    }

    debugPrint('pageViewScrollEnabled: ${state.pageViewScrollEnabled}');

    return state.viewState == WeekViewState.WHOLE_LOADING ? _WholeLoadingView()
      : state.viewState == WeekViewState.NETWORK_ERROR ? _NetworkErrorView(bloc: _bloc)
      : WillPopScope(
      onWillPop: () async {
        return !_unfocusTextFieldIfAny();
      },
      child: Column(
        children: [
          _Header(
            key: _headerKey,
            bloc: _bloc,
            displayYear: state.year.toString(),
            displayMonthAndWeek: AppLocalizations.of(context).getMonthAndNthWeek(state.month, state.nthWeek),
            pageViewScrollEnabled: state.pageViewScrollEnabled,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  physics: state.pageViewScrollEnabled ? PageScrollPhysics() : NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: WeekScreen.MAX_WEEK_PAGE,
                  itemBuilder: (context, index) {
                    final weekRecord = state.getWeekRecordForPageIndex(index);
                    if (weekRecord == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return _WeekRecord(
                        key: index == WeekScreen.INITIAL_WEEK_PAGE ? _firstWeekRecordKey
                          : weekRecord.showFirstCompletableDayTutorialIndex >= 0 ? _firstCompletableWeekRecord
                          : null,
                        bloc: _bloc,
                        weekRecord: weekRecord,
                        focusNodeProvider: _getOrCreateFocusNode,
                        scrollController: _scrollController,
                        memoKey: index == WeekScreen.INITIAL_WEEK_PAGE ? _firstCheckPointsKey : null,
                        todayPreviewKey: _todayPreviewKey,
                        firstCompletableDayPreviewKey: _firstCompletableDayPreview,
                      );
                    }
                  },
                  onPageChanged: (changedIndex) {
                    _unfocusTextFieldIfAny();
                    _headerShadowKey.currentState.updateShadowVisibility(false);
                    _bloc.onWeekRecordPageIndexChanged(changedIndex);
                  },
                ),
                _HeaderShadow(
                  key: _headerShadowKey,
                  scrollController: _scrollController,
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }

  void _checkViewsBuiltToStartTutorial() {
    // check for one element. Simple checking.
    if (_firstCheckPointsKey.currentContext?.findRenderObject() == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _checkViewsBuiltToStartTutorial());
      return;
    }

    _bloc.startTutorial(context, this);
  }

  Future<void> _scrollToTodayPreview() async {
    final RenderBox weekRecordRenderBox = _firstWeekRecordKey.currentContext?.findRenderObject();
    final RenderBox todayPreviewRenderBox = _todayPreviewKey.currentContext?.findRenderObject();
    if (weekRecordRenderBox == null || todayPreviewRenderBox == null || !_scrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToTodayPreview());
      return;
    }

    final weekRecordTop = weekRecordRenderBox.localToGlobal(Offset.zero).dy;
    final weekRecordHeight = weekRecordRenderBox.size.height;
    final todayPreviewTop = todayPreviewRenderBox.localToGlobal(Offset.zero).dy;
    final todayPreviewHeight = todayPreviewRenderBox.size.height;

    if (todayPreviewTop < weekRecordTop || todayPreviewTop + todayPreviewHeight > weekRecordTop + weekRecordHeight) {
      final currentScrollOffset = _scrollController.offset;
      final targetScrollOffset = max<double>(todayPreviewTop + todayPreviewHeight - weekRecordTop - weekRecordHeight, 0);
      // min 300, max 700
      final duration = Duration(milliseconds: max<int>(300, min<int>(700, ((targetScrollOffset - currentScrollOffset).abs() * 10).toInt())));

      return await _scrollController.animateTo(
        targetScrollOffset,
        duration: duration,
        curve: Curves.ease,
      );
    }
  }

  void _checkViewsBuiltToShowFirstCompletableDayTutorial() {
    if (_firstCompletableDayPreview.currentContext?.findRenderObject() == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _checkViewsBuiltToShowFirstCompletableDayTutorial());
      return;
    }

    _bloc.showFirstCompletableDayTutorial(context, this);
  }

  Future<void> _scrollToFirstCheckPoints() async {
    final RenderBox weekRecordRenderBox = _firstWeekRecordKey.currentContext?.findRenderObject();
    final RenderBox checkPointsRenderBox = _firstCheckPointsKey.currentContext?.findRenderObject();
    if (weekRecordRenderBox == null || checkPointsRenderBox == null || !_scrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToFirstCheckPoints());
      return;
    }

    final weekRecordTop = weekRecordRenderBox.localToGlobal(Offset.zero).dy;
    final weekRecordHeight = weekRecordRenderBox.size.height;
    final checkPointsTop = checkPointsRenderBox.localToGlobal(Offset.zero).dy;
    final checkPointsHeight = checkPointsRenderBox.size.height;

    if (checkPointsTop < weekRecordTop || checkPointsTop + checkPointsHeight > weekRecordTop + weekRecordHeight) {
      final currentScrollOffset = _scrollController.offset;
      final targetScrollOffset = max<double>(checkPointsTop + checkPointsHeight - weekRecordTop - weekRecordHeight, 0);
      final duration = Duration(milliseconds: max<int>(300, min<int>(700, ((targetScrollOffset - currentScrollOffset).abs() * 10).toInt())));

      return await _scrollController.animateTo(
        targetScrollOffset,
        duration: duration,
        curve: Curves.ease,
      );
    }
  }

  Future<void> _scrollToFirstCompletableDayPreview() async {
    final RenderBox weekRecordRenderBox = _firstCompletableWeekRecord.currentContext?.findRenderObject() ?? _firstWeekRecordKey.currentContext?.findRenderObject();
    final RenderBox dayPreviewRenderBox = _firstCompletableDayPreview.currentContext?.findRenderObject();
    if (weekRecordRenderBox == null || dayPreviewRenderBox == null || !_scrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToFirstCompletableDayPreview());
      return;
    }

    final weekRecordTop = weekRecordRenderBox.localToGlobal(Offset.zero).dy;
    final weekRecordHeight = weekRecordRenderBox.size.height;
    final checkPointsTop = dayPreviewRenderBox.localToGlobal(Offset.zero).dy;
    final checkPointsHeight = dayPreviewRenderBox.size.height;

    if (checkPointsTop < weekRecordTop || checkPointsTop + checkPointsHeight > weekRecordTop + weekRecordHeight) {
      final currentScrollOffset = _scrollController.offset;
      final targetScrollOffset = max<double>(checkPointsTop + checkPointsHeight - weekRecordTop - weekRecordHeight, 0);
      final duration = Duration(milliseconds: max<int>(300, min<int>(700, ((targetScrollOffset - currentScrollOffset).abs() * 10).toInt())));

      return await _scrollController.animateTo(
        targetScrollOffset,
        duration: duration,
        curve: Curves.ease,
      );
    }
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

  @override
  ViewLayoutInfo Function() getHeaderFinder() {
    return () {
      final RenderBox box = _headerKey.currentContext?.findRenderObject();
      return ViewLayoutInfo.create(box);
    };
  }

  @override
  ViewLayoutInfo Function() getCheckPointsFinder() {
    return () {
      final RenderBox box = _firstCheckPointsKey.currentContext?.findRenderObject();
      return ViewLayoutInfo.create(box);
    };
  }

  @override
  Future<void> scrollToTodayPreview() async {
    return _scrollToTodayPreview();
  }

  @override
  Future<void> scrollToCheckPoints() async {
    return _scrollToFirstCheckPoints();
  }

  @override
  ViewLayoutInfo Function() getTodayPreviewFinder() {
    return () {
      final RenderBox box = _todayPreviewKey.currentContext?.findRenderObject();
      return ViewLayoutInfo.create(box);
    };
  }

  @override
  Future<void> scrollToFirstCompletableDayPreview() async {
    return _scrollToFirstCompletableDayPreview();
  }

  @override
  ViewLayoutInfo Function() getFirstCompletableDayPreviewFinder() {
    return () {
      final RenderBox box = _firstCompletableDayPreview.currentContext?.findRenderObject();
      return ViewLayoutInfo.create(box);
    };
  }
}

class _WholeLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BACKGROUND_WHITE,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}

class _NetworkErrorView extends StatelessWidget {
  final WeekBloc bloc;

  _NetworkErrorView({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BACKGROUND_WHITE,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            onPressed: () => bloc.onNetworkErrorRetryClicked(),
            child: Text(
              AppLocalizations.of(context).retry,
            ),
          ),
          Text(
            AppLocalizations.of(context).weekScreenNetworkErrorReason,
            textAlign: TextAlign.center,
          )
        ],
      )
    );
  }
}

class _Header extends StatelessWidget {
  final WeekBloc bloc;
  final String displayYear;
  final String displayMonthAndWeek;
  final bool pageViewScrollEnabled;

  _Header({
    Key key,
    @required this.bloc,
    @required this.displayYear,
    @required this.displayMonthAndWeek,
    @required this.pageViewScrollEnabled,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 4,),
        InkWell(
          onTap: pageViewScrollEnabled ? () => bloc.onPrevArrowClicked() : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/ic_prev.png'),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Text(
                  displayYear,
                  style: TextStyle(
                    color: AppColors.TEXT_BLACK_LIGHT,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
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
        ),
        InkWell(
          onTap: pageViewScrollEnabled ? () => bloc.onNextArrowClicked() : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('assets/ic_next.png'),
          ),
        ),
        SizedBox(width: 4,),
      ],
    );
  }
}

class _WeekRecord extends StatelessWidget {
  final WeekBloc bloc;
  final WeekRecord weekRecord;
  final FocusNode Function(String key) focusNodeProvider;
  final ScrollController scrollController;
  final Key memoKey;
  final Key todayPreviewKey;
  final Key firstCompletableDayPreviewKey;

  _WeekRecord({
    Key key,
    @required this.bloc,
    @required this.weekRecord,
    @required this.focusNodeProvider,
    @required this.scrollController,
    @required this.memoKey,
    @required this.todayPreviewKey,
    @required this.firstCompletableDayPreviewKey,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstCompletableDayPreviewIndex = weekRecord.showFirstCompletableDayTutorialIndex;
    final dayPreviews = weekRecord.dayPreviews;

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          _CheckPointsBox(
            bloc: bloc,
            weekRecord: weekRecord,
            focusNodeProvider: focusNodeProvider,
            memoKey: memoKey,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12,),
            child: Column(
              children: List.generate(dayPreviews.length, (index) {
                final item = dayPreviews[index];
                return _DayPreviewItem(
                  key: item.isToday ? todayPreviewKey : null,
                  bloc: bloc,
                  weekRecord: weekRecord,
                  dayPreview: item,
                  isFirstItem: index == 0,
                  thumbnailKey: index == firstCompletableDayPreviewIndex ? firstCompletableDayPreviewKey : null,
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
  final Key memoKey;

  _CheckPointsBox({
    @required this.bloc,
    @required this.weekRecord,
    @required this.focusNodeProvider,
    @required this.memoKey,
  });

  @override
  Widget build(BuildContext context) {
    final checkPoints = weekRecord.checkPoints;

    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
      child: Container(
        key: memoKey,
        decoration: BoxDecoration(
          color: AppColors.PRIMARY,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12,),
              child: Text(
                'CHECK POINTS',
                style: TextStyle(
                  color: AppColors.TEXT_WHITE,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4, right: 12, bottom: 12,),
              child: Column(
                children: List.generate(checkPoints.length, (index) {
                  final checkPoint = index == 0 && weekRecord.containsToday ? checkPoints[index].buildNew(hint: AppLocalizations.of(context).checkPointHint)
                    : checkPoints[index];
                  return _CheckPointItem(
                    bloc: bloc,
                    weekRecord: weekRecord,
                    checkPoint: checkPoint,
                    focusNodeProvider: focusNodeProvider,
                  );
                }),
              ),
            ),
          ],
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
      padding: const EdgeInsets.only(top: 4),
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
          SizedBox(width: 4,),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 38,),
              child: Container(
                alignment: Alignment.center,
                child: AppTextField(
                  focusNode: focusNodeProvider(checkPoint.key),
                  text: checkPoint.text,
                  textSize: 14,
                  textColor: AppColors.TEXT_WHITE,
                  hintText: checkPoint.hint,
                  hintTextSize: 14,
                  hintColor: AppColors.TEXT_WHITE_DARK,
                  onChanged: (s) => bloc.onCheckPointTextChanged(checkPoint, s),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  cursorColor: AppColors.TEXT_WHITE,
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
  final DayPreview dayPreview;
  final bool isFirstItem;
  final Key thumbnailKey;

  _DayPreviewItem({
    Key key,
    @required this.bloc,
    @required this.weekRecord,
    @required this.dayPreview,
    @required this.isFirstItem,
    @required this.thumbnailKey,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final toDoPreviews = dayPreview.toDoPreviews;
    final isLightColor = dayPreview.isLightColor;
    final hasAnyToDo = dayPreview.totalToDosCount > 0;
    final firstToDo = toDoPreviews.length >= 1 ? toDoPreviews[0] : null;
    final secondToDo = toDoPreviews.length >= 2 ? toDoPreviews[1] : null;

    return InkWell(
      onTap: () => bloc.onDayPreviewClicked(context, dayPreview),
      child: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _DayPreviewItemThumbnail(
                bloc: bloc,
                text: dayPreview.thumbnailString,
                ratio: dayPreview.ratio,
                bgColor: !hasAnyToDo ? AppColors.BACKGROUND_GREY : AppColors.PRIMARY_LIGHT_LIGHT,
                fgColor: isLightColor ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
                isTopLineVisible: dayPreview.isTopLineVisible,
                isTopLineLightColor: dayPreview.isTopLineLightColor,
                isBottomLineVisible: dayPreview.isBottomLineVisible,
                isBottomLineLightColor: dayPreview.isBottomLineLightColor,
                canBeMarkedCompleted: dayPreview.canBeMarkedCompleted,
                date: dayPreview.date,
                isFirstItem: isFirstItem,
                thumbnailKey: thumbnailKey,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context).getDayPreviewTitle(dayPreview.month, dayPreview.day, dayPreview.weekday),
                            style: TextStyle(
                              fontSize: 18,
                              color: isLightColor ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 8),
                          dayPreview.isToday == true ? _DayPreviewItemTodayText() : const SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(height: 4,),
                      _DayPreviewItemMemo(
                        isLightColor: isLightColor,
                        memo: dayPreview.memoPreview,
                      ),
                      SizedBox(height: 4,),
                      _DayPreviewItemToDos(
                        isLightColor: isLightColor,
                        firstToDo: firstToDo,
                        secondToDo: secondToDo,
                        moreToDosCount: dayPreview.totalToDosCount - toDoPreviews.length,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DayPreviewItemThumbnail extends StatelessWidget {
  final WeekBloc bloc;
  final String text;
  final double ratio;
  final Color bgColor;
  final Color fgColor;
  final bool isTopLineVisible;
  final bool isTopLineLightColor;
  final bool isBottomLineVisible;
  final bool isBottomLineLightColor;
  final bool canBeMarkedCompleted;
  final DateTime date;
  final bool isFirstItem;
  final Key thumbnailKey;

  _DayPreviewItemThumbnail({
    @required this.bloc,
    @required this.text,
    @required this.ratio,
    @required this.bgColor,
    @required this.fgColor,
    @required this.isTopLineVisible,
    @required this.isTopLineLightColor,
    @required this.isBottomLineVisible,
    @required this.isBottomLineLightColor,
    @required this.canBeMarkedCompleted,
    @required this.date,
    @required this.isFirstItem,
    @required this.thumbnailKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          isBottomLineVisible ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.bottomRight,
                  heightFactor: 0.5,
                  child: Container(
                    color: isBottomLineLightColor ? AppColors.PRIMARY_LIGHT_LIGHT : AppColors.PRIMARY,
                    width: 2,
                  ),
                ),
              ),
            ),
          ) : const SizedBox.shrink(),
          !isTopLineVisible ? const SizedBox.shrink()
            : isFirstItem ? Align(
            alignment: Alignment.centerLeft,
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: isTopLineLightColor ? AppColors.PRIMARY_LIGHT_LIGHT : AppColors.PRIMARY,
                  height: 2,
                ),
              ),
            ),
          ) : Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topRight,
                  heightFactor: 0.5,
                  child: Container(
                    color: isTopLineLightColor ? AppColors.PRIMARY_LIGHT_LIGHT : AppColors.PRIMARY,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          _ThumbnailCircle(
            key: thumbnailKey,
            color: bgColor,
            ratio: 1.0,
          ),
          ratio > 0 ? _ThumbnailCircle(
            color: fgColor,
            ratio: ratio,
          ) : const SizedBox.shrink(),
          canBeMarkedCompleted ? SizedBox(
            width: 48,
            height: 48,
            child: GestureDetector(
              child: FlareActor(
                'assets/seed_awaiting.flr',
                animation: 'idle',
              ),
              onTap: () => bloc.onMarkDayCompletedClicked(context, date),
            )
          ): Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.TEXT_WHITE,
                  fontSize: 14,
                ),
                textScaleFactor: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPreviewItemMemo extends StatelessWidget {
  final bool isLightColor;
  final String memo;

  _DayPreviewItemMemo({
    @required this.isLightColor,
    @required this.memo,
  });

  @override
  Widget build(BuildContext context) {
    final isMemoEmpty = memo.length == 0;

    return Row(
      children: <Widget>[
        Image.asset(isLightColor ? 'assets/ic_preview_memo_light.png' : 'assets/ic_preview_memo.png'),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            isMemoEmpty ? '-' : memo,
            style: TextStyle(
              fontSize: 12,
              color: isLightColor || isMemoEmpty ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
            ),
            strutStyle: StrutStyle(
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class _DayPreviewItemToDos extends StatelessWidget {
  final bool isLightColor;
  final ToDo firstToDo;
  final ToDo secondToDo;
  final int moreToDosCount;

  _DayPreviewItemToDos({
    @required this.isLightColor,
    @required this.firstToDo,
    @required this.secondToDo,
    @required this.moreToDosCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasNoToDos = firstToDo == null && secondToDo == null;
    final hasOneToDo = firstToDo != null && secondToDo == null;

    return Row(
      children: <Widget>[
        Image.asset(isLightColor ? 'assets/ic_preview_todo_light.png' : 'assets/ic_preview_todo.png'),
        SizedBox(width: 8),
        hasNoToDos ? Text(
          '-',
          style: TextStyle(
            fontSize: 12,
            color: isLightColor || hasNoToDos ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
          ),
          strutStyle: StrutStyle(
            fontSize: 12,
          ),
        ): hasOneToDo ? Expanded(
          child: Text(
            firstToDo.text,
            style: TextStyle(
              fontSize: 12,
              color: isLightColor || firstToDo.isDone ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
              decoration: firstToDo.isDone ? TextDecoration.lineThrough : null,
              decorationColor: AppColors.TEXT_BLACK_LIGHT,
              decorationThickness: 2,
            ),
            strutStyle: StrutStyle(
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ) : Expanded(
          child: Row(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 70,
                ),
                child: Text(
                  firstToDo.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: isLightColor || firstToDo.isDone ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
                    decoration: firstToDo.isDone ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.TEXT_BLACK_LIGHT,
                    decorationThickness: 2,
                  ),
                  strutStyle: StrutStyle(
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                ', ',
                style: TextStyle(
                  fontSize: 12,
                  color: isLightColor ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
                ),
                strutStyle: StrutStyle(
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 70,
                      ),
                      child: Text(
                        secondToDo.text,
                        style: TextStyle(
                          fontSize: 12,
                          color: isLightColor || secondToDo.isDone ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
                          decoration: secondToDo.isDone ? TextDecoration.lineThrough : null,
                          decorationColor: AppColors.TEXT_BLACK_LIGHT,
                          decorationThickness: 2,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    moreToDosCount > 0 ? Expanded(
                      child: Text(
                        AppLocalizations.of(context).getMoreToDos(moreToDosCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.TEXT_BLACK_LIGHT,
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      )
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ThumbnailCircle extends StatelessWidget {
  final Color color;
  final double ratio;

  _ThumbnailCircle({
    Key key,
    @required this.color,
    @required this.ratio,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipPath(
        clipper: ratio >= 0 && ratio < 1 ? _ThumbnailCircleClipper(ratio: ratio) : null,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.BACKGROUND_WHITE,
                    width: 4,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 2,
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThumbnailCircleClipper extends CustomClipper<Path> {
  final double ratio;

  _ThumbnailCircleClipper({
    @required this.ratio,
  });

  @override
  Path getClip(Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final path = Path()
      ..moveTo(centerX, centerY)
      ..arcTo(
        Rect.fromCenter(center: Offset(centerX, centerY),
          width: size.width,
          height: size.height),
        _degreesToRadians(-90),
        _degreesToRadians(360 * ratio),
        false
      );
    path.close();
    return path;
  }

  double _degreesToRadians(double degrees) {
    return degrees / 180 * pi;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _DayPreviewItemTodayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        textAlign: TextAlign.center,
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
