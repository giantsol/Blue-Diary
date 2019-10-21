
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
import 'package:todo_app/domain/entity/ToDo.dart';
import 'package:todo_app/domain/entity/WeekRecord.dart';
import 'package:todo_app/presentation/week/WeekBloc.dart';
import 'package:todo_app/presentation/week/WeekState.dart';
import 'package:todo_app/presentation/widgets/AppTextField.dart';

class WeekScreen extends StatefulWidget {
  static const MAX_WEEk_PAGE = 100;
  static const INITIAL_WEEK_PAGE = 50;

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
  PageController _pageController;
  final Map<String, FocusNode> _focusNodes = {};
  ScrollController _scrollController;
  final GlobalKey<_HeaderShadowState> _headerShadowKey = GlobalKey();

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
        _pageController.jumpToPage(_bloc.getInitialState().initialWeekRecordPageIndex);
      });
    }

    if (state.animateToPageEvent != -1) {
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        _pageController.animateToPage(state.animateToPageEvent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.ease,
        );
      });
    }

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
                PageView.builder(
                  controller: _pageController,
                  itemCount: WeekScreen.MAX_WEEk_PAGE,
                  itemBuilder: (context, index) {
                    final weekRecord = state.getWeekRecordForPageIndex(index);
                    if (weekRecord == null) {
                      return Center(child: CircularProgressIndicator(),);
                    } else {
                      return _WeekRecord(
                        bloc: _bloc,
                        weekRecord: weekRecord,
                        focusNodeProvider: _getOrCreateFocusNode,
                        scrollController: _scrollController,
                      );
                    }
                  },
                  onPageChanged: (changedIndex) {
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
    return Container(
      color: AppColors.BACKGROUND_WHITE,
      alignment: Alignment.center,
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
    return Row(
      children: <Widget>[
        SizedBox(width: 4,),
        InkWell(
          onTap: () => bloc.onPrevArrowClicked(),
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
          onTap: () => bloc.onNextArrowClicked(),
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
            padding: const EdgeInsets.only(top: 12,),
            child: Column(
              children: List.generate(weekRecord.dayPreviews.length, (index) {
                return _DayPreviewItem(
                  bloc: bloc,
                  weekRecord: weekRecord,
                  dayPreview: weekRecord.dayPreviews[index]
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
      padding: const EdgeInsets.only(left: 24, top: 12, right: 24),
      child: Container(
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
                  onChanged: (s) => bloc.onCheckPointTextChanged(checkPoint, s),
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
  final DayPreview dayPreview;

  _DayPreviewItem({
    @required this.bloc,
    @required this.weekRecord,
    @required this.dayPreview,
  });

  @override
  Widget build(BuildContext context) {
    final isLightColor = dayPreview.isLightColor;
    final hasAnyToDo = dayPreview.totalToDosCount > 0;
    final firstToDo = dayPreview.toDoPreviews.length >= 1 ? dayPreview.toDoPreviews[0] : null;
    final secondToDo = dayPreview.toDoPreviews.length >= 2 ? dayPreview.toDoPreviews[1] : null;
    return InkWell(
      onTap: () => bloc.onDayPreviewClicked(context, dayPreview),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _DayPreviewItemThumbnail(
                text: dayPreview.thumbnailString,
                ratio: dayPreview.ratio,
                bgColor: !hasAnyToDo ? AppColors.BACKGROUND_GREY : AppColors.PRIMARY_LIGHT_LIGHT,
                fgColor: isLightColor ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
                isTopLineVisible: dayPreview.isTopLineVisible,
                isTopLineLightColor: dayPreview.isTopLineLightColor,
                isBottomLineVisible: dayPreview.isBottomLineVisible,
                isBottomLineLightColor: dayPreview.isBottomLineLightColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8,),
                  child: Column(
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
                      _DayPreviewItemToDos(
                        isLightColor: isLightColor,
                        firstToDo: firstToDo,
                        secondToDo: secondToDo,
                        moreToDosCount: dayPreview.totalToDosCount - dayPreview.toDoPreviews.length,
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
  final String text;
  final double ratio;
  final Color bgColor;
  final Color fgColor;
  final bool isTopLineVisible;
  final bool isTopLineLightColor;
  final bool isBottomLineVisible;
  final bool isBottomLineLightColor;

  _DayPreviewItemThumbnail({
    @required this.text,
    @required this.ratio,
    @required this.bgColor,
    @required this.fgColor,
    @required this.isTopLineVisible,
    @required this.isTopLineLightColor,
    @required this.isBottomLineVisible,
    @required this.isBottomLineLightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        isTopLineVisible ? Align(
          alignment: Alignment.topCenter,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.5,
              child: Container(
                color: isTopLineLightColor ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
                width: 2,
              ),
            ),
          ),
        ) : const SizedBox.shrink(),
        isBottomLineVisible ? Align(
          alignment: Alignment.bottomCenter,
          child: ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.5,
              child: Container(
                color: isBottomLineLightColor ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
                width: 2,
              ),
            ),
          ),
        ) : const SizedBox.shrink(),
        _ThumbnailCircle(
          color: bgColor,
          ratio: 1.0,
        ),
        _ThumbnailCircle(
          color: fgColor,
          ratio: ratio,
        ),
        Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.TEXT_WHITE,
              fontSize: 14,
            ),
            textScaleFactor: 1.0,
          ),
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.only(left: 1,),
      child: Row(
        children: <Widget>[
          Image.asset(isLightColor ? 'assets/ic_preview_memo_light.png' : 'assets/ic_preview_memo.png'),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              memo,
              style: TextStyle(
                fontSize: 12,
                color: isLightColor ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
              ),
              strutStyle: StrutStyle(
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
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
            color: isLightColor ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
          ),
        ) : hasOneToDo ? Expanded(
          child: Text(
            firstToDo.text,
            style: TextStyle(
              fontSize: 12,
              color: isLightColor || firstToDo.isDone ? AppColors.TEXT_BLACK_LIGHT
                : AppColors.TEXT_BLACK,
              decoration: firstToDo.isDone ? TextDecoration.lineThrough : null,
              decorationColor: AppColors.TEXT_BLACK_LIGHT,
              decorationThickness: 2,
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
                    color: isLightColor || firstToDo.isDone ? AppColors.TEXT_BLACK_LIGHT
                      : AppColors.TEXT_BLACK,
                    decoration: firstToDo.isDone ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.TEXT_BLACK_LIGHT,
                    decorationThickness: 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                ', ',
                style: TextStyle(
                  fontSize: 12,
                  color: isLightColor ? AppColors.TEXT_BLACK_LIGHT
                    : AppColors.TEXT_BLACK,
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
                          color: isLightColor || secondToDo.isDone ? AppColors.TEXT_BLACK_LIGHT
                            : AppColors.TEXT_BLACK,
                          decoration: secondToDo.isDone ? TextDecoration.lineThrough : null,
                          decorationColor: AppColors.TEXT_BLACK_LIGHT,
                          decorationThickness: 2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    moreToDosCount > 0 ? Text(
                      AppLocalizations.of(context).getMoreToDos(moreToDosCount),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.TEXT_BLACK_LIGHT,
                      ),
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
    @required this.color,
    @required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipPath(
        clipper: ratio < 1 ? _ThumbnailCircleClipper(
          ratio: ratio,
        ) : null,
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