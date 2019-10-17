
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/CheckPoint.dart';
import 'package:todo_app/domain/entity/DayPreview.dart';
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
  final GlobalKey<_HeaderShadowState> _headerShadowKey = GlobalKey();

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
    return SafeArea(
      child: state.viewState == WeekViewState.WHOLE_LOADING ? _WholeLoadingView()
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
                      _headerShadowKey.currentState.updateShadowVisibility(false);
                      _bloc.onWeekRecordPageChanged(changedIndex);
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          SizedBox(width: 4,),
          InkWell(
            onTap: () { },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/ic_prev.png'),
            ),
          ),
          Expanded(
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
          InkWell(
            onTap: () { },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/ic_next.png'),
            ),
          ),
          SizedBox(width: 4,),
        ],
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
              padding: const EdgeInsets.only(left: 8, top: 3, right: 12, bottom: 12,),
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
  final DayPreview dayPreview;

  _DayPreviewItem({
    @required this.bloc,
    @required this.weekRecord,
    @required this.dayPreview,
  });

  @override
  Widget build(BuildContext context) {
    final isPastDay = true;
    final hasAnyToDo = dayPreview.toDos.length > 0;
    return InkWell(
      onTap: () => bloc.onDayPreviewClicked(context, dayPreview),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _DayPreviewItemThumbnail(
                text: dayPreview.thumbnailString,
                ratio: dayPreview.filledRatio,
                bgColor: !hasAnyToDo ? AppColors.BACKGROUND_GREY : AppColors.PRIMARY_LIGHT_LIGHT,
                fgColor: isPastDay ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
                isTopLineVisible: false,
                isBottomLineVisible: true,
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
                            AppLocalizations.of(context).getDayPreviewTitle(dayPreview.month, dayPreview.day),
                            style: TextStyle(
                              fontSize: 18,
                              color: isPastDay ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
                            ),
                          ),
                          SizedBox(width: 8),
                          dayPreview.isToday == true ? _DayPreviewItemTodayText() : const SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        children: <Widget>[
                          Image.asset(isPastDay ? 'assets/ic_preview_memo_light.png' : 'assets/ic_preview_memo.png'),
                          SizedBox(width: 8),
                          Text(
                            '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: isPastDay ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(isPastDay ? 'assets/ic_preview_todo_light.png' : 'assets/ic_preview_todo.png'),
                          SizedBox(width: 8),
                          Text(
                            'Flutter 개발',
                            style: TextStyle(
                              fontSize: 12,
                              color: isPastDay ? AppColors.TEXT_BLACK_LIGHT : AppColors.TEXT_BLACK,
                            ),
                          )
                        ],
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
  final bool isBottomLineVisible;

  _DayPreviewItemThumbnail({
    @required this.text,
    @required this.ratio,
    @required this.bgColor,
    @required this.fgColor,
    @required this.isTopLineVisible,
    @required this.isBottomLineVisible,
  });

  @override
  Widget build(BuildContext context) {
    final isBothLineVisible = isTopLineVisible && isBottomLineVisible;
    final isLineVisible = isTopLineVisible || isBottomLineVisible;
    final lineAlignment = isBothLineVisible ? Alignment.center
      : isTopLineVisible ? Alignment.topCenter
      : Alignment.bottomCenter;
    final heightFactor = isBothLineVisible ? 1.0 : 0.5;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        isLineVisible ? Align(
          alignment: lineAlignment,
          child: ClipRect(
            child: Align(
              alignment: lineAlignment,
              heightFactor: heightFactor,
              child: Container(
                color: AppColors.PRIMARY,
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