
import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';
import 'package:todo_app/presentation/day/DayScreenTutorialCallback.dart';

class DayScreenTutorial extends StatefulWidget {
  final DayScreenTutorialCallback dayScreenTutorialCallback;

  DayScreenTutorial({
    @required this.dayScreenTutorialCallback,
  });

  @override
  State createState() => _DayScreenTutorialState();
}

class _DayScreenTutorialState extends State<DayScreenTutorial> with TickerProviderStateMixin {
  AnimationController _tutorialFadeInController;

  AnimationController _firstPhaseController;
  AnimationController _secondPhaseController;
  AnimationController _thirdPhaseController;

  _FirstPhase _firstPhase;
  _SecondPhase _secondPhase;
  _ThirdPhase _thirdPhase;

  int _currentPhase = -1;

  @override
  void initState() {
    super.initState();

    _tutorialFadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _tutorialFadeInController.forward();
    _tutorialFadeInController.addStatusListener(_tutorialFadeInListener);

    _firstPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _secondPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _thirdPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _tutorialFadeInController.dispose();

    _firstPhaseController.dispose();
    _secondPhaseController.dispose();
    _thirdPhaseController.dispose();

    super.dispose();
  }

  void _tutorialFadeInListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _tutorialFadeInController.removeStatusListener(_tutorialFadeInListener);
      _updatePhase(0);
    }
  }

  void _updatePhase(int phase) {
    if (phase == 0) {
      if (_currentPhase == -1) {
        _firstPhaseController.forward();
      } else {
        _secondPhaseController.reverse();
        _firstPhaseController.forward();
      }
    } else if (phase == 1) {
      if (_currentPhase == 0) {
        _firstPhaseController.reverse();
        _secondPhaseController.forward();
      } else {
        _thirdPhaseController.reverse();
        _secondPhaseController.forward();
      }
    } else if (phase == 2) {
      _secondPhaseController.reverse();
      _thirdPhaseController.forward();
    } else {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _currentPhase = phase;
    });
  }

  @override
  Widget build(BuildContext context) {
    _firstPhase = _FirstPhase(
      controller: _firstPhaseController,
      headerFinder: widget.dayScreenTutorialCallback.getHeaderFinder(),
    );

    _secondPhase = _SecondPhase(
      controller: _secondPhaseController,
      memoFinder: widget.dayScreenTutorialCallback.getMemoFinder(),
    );

    _thirdPhase = _ThirdPhase(
      controller: _thirdPhaseController,
      addToDoFinder: widget.dayScreenTutorialCallback.getAddToDoFinder(),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, -1);
          return false;
        },
        child: FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _tutorialFadeInController,
            curve: Curves.ease,
          )),
          child: ClipPath(
            clipper: _getClipper(),
            child: Container(
              color: AppColors.SCRIM_TUTORIAL,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _currentPhase >= 1 ? Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _onPrevClicked,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            AppLocalizations.of(context).prev,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ): const SizedBox.shrink(),
                  _currentPhase >= 0 ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: _Dots(
                        currentPhase: _currentPhase,
                      ),
                    ),
                  ): const SizedBox.shrink(),
                  _currentPhase >= 0 ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _onNextClicked,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _currentPhase < 2 ? AppLocalizations.of(context).next
                              : AppLocalizations.of(context).done,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ): const SizedBox.shrink(),
                  _firstPhase,
                  _secondPhase,
                  _thirdPhase,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomClipper _getClipper() {
    if (_currentPhase == 0) {
      return _firstPhase.clipper;
    } else if (_currentPhase == 1) {
      return _secondPhase.clipper;
    } else if (_currentPhase == 2) {
      return _thirdPhase.clipper;
    } else {
      return null;
    }
  }

  void _onPrevClicked() {
    _updatePhase(_currentPhase - 1);
  }

  void _onNextClicked() {
    _updatePhase(_currentPhase + 1);
  }
}

class _Dots extends StatelessWidget {
  final int currentPhase;

  _Dots({
    @required this.currentPhase,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPhase == 0 ? Colors.white : AppColors.TUTORIAL_PROGRESS_INACTIVE,
          ),
        ),
        SizedBox(width: 8,),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPhase == 1 ? Colors.white : AppColors.TUTORIAL_PROGRESS_INACTIVE,
          ),
        ),
        SizedBox(width: 8,),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPhase == 2 ? Colors.white : AppColors.TUTORIAL_PROGRESS_INACTIVE,
          ),
        ),
      ],
    );
  }
}

class _FirstPhase extends StatelessWidget {
  final AnimationController controller;
  final ViewLayoutInfo Function() headerFinder;
  final _FirstPhaseClipper clipper;

  _FirstPhase({
    @required this.controller,
    @required this.headerFinder,
  }): clipper = _FirstPhaseClipper(
    headerFinder: headerFinder,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(controller),
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(controller),
              child: Text(
                AppLocalizations.of(context).dayTutorialSwipe,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controller),
            child: Container(
              padding: const EdgeInsets.only(left: 19),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Transform.rotate(
                  angle: pi,
                  child: FlareActor(
                    'assets/ic_swipe_indicator.flr',
                    animation: 'idle',
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(controller),
            child: Container(
              padding: const EdgeInsets.only(right: 19),
              child: SizedBox(
                width: 24,
                height: 24,
                child: FlareActor(
                  'assets/ic_swipe_indicator.flr',
                  animation: 'idle',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _FirstPhaseClipper extends CustomClipper<Path> {
  final ViewLayoutInfo Function() headerFinder;

  _FirstPhaseClipper({
    @required this.headerFinder,
  });

  @override
  Path getClip(Size size) {
    final header = headerFinder();
    final path = Path()
      ..addRect(Rect.fromLTWH(header.left, header.top, header.width, header.height))
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _SecondPhase extends StatelessWidget {
  final AnimationController controller;
  final ViewLayoutInfo Function() memoFinder;
  final _SecondPhaseClipper clipper;

  _SecondPhase({
    @required this.controller,
    @required this.memoFinder,
  }): clipper = _SecondPhaseClipper(
    memoFinder: memoFinder,
  );

  @override
  Widget build(BuildContext context) {
    final checkPoints = memoFinder();
    final checkPointsBottom = checkPoints.top + checkPoints.height;
    return Positioned(
      top: checkPointsBottom + 8,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(controller),
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(controller),
          child: Text(
            AppLocalizations.of(context).dayTutorialMemo,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _SecondPhaseClipper extends CustomClipper<Path> {
  final ViewLayoutInfo Function() memoFinder;

  _SecondPhaseClipper({
    @required this.memoFinder,
  });

  @override
  Path getClip(Size size) {
    final memo = memoFinder();
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(memo.left, memo.top, memo.width, memo.height),
        const Radius.circular(6)),
      )
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _ThirdPhase extends StatefulWidget {
  final AnimationController controller;
  final ViewLayoutInfo Function() addToDoFinder;
  final _ThirdPhaseClipper clipper;

  _ThirdPhase({
    @required this.controller,
    @required this.addToDoFinder,
  }): clipper = _ThirdPhaseClipper(
    addToDoFinder: addToDoFinder,
  );

  @override
  State createState() => _ThirdPhaseState();
}

class _ThirdPhaseState extends State<_ThirdPhase> {
  double _myHeight = 0;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_updateMyHeight);

    final todayPreview = widget.addToDoFinder();
    return Positioned(
      top: todayPreview.top - _myHeight - 8,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(widget.controller),
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0))
            .animate(widget.controller),
          child: Text(
            AppLocalizations.of(context).dayTutorialAddToDo,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _updateMyHeight(Duration _) {
    final measuredHeight = context.size?.height ?? 0;
    if (_myHeight != measuredHeight) {
      setState(() {
        _myHeight = measuredHeight;
      });
    }
  }
}

class _ThirdPhaseClipper extends CustomClipper<Path> {
  final ViewLayoutInfo Function() addToDoFinder;

  _ThirdPhaseClipper({
    @required this.addToDoFinder,
  });

  @override
  Path getClip(Size size) {
    final addToDo = addToDoFinder();
    final path = Path()
      ..addOval(Rect.fromLTWH(addToDo.left, addToDo.top, addToDo.width, addToDo.height))
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
