
import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';
import 'package:todo_app/presentation/week/WeekScreenTutorialCallback.dart';

// Not using bloc pattern here since it's just a tutorial screen..
// Quite complex though :(

class WeekScreenTutorial extends StatefulWidget {
  final WeekScreenTutorialCallback weekScreenTutorialCallback;

  WeekScreenTutorial({
    @required this.weekScreenTutorialCallback,
  });

  @override
  State createState() => _WeekScreenTutorialState();
}

class _WeekScreenTutorialState extends State<WeekScreenTutorial> with TickerProviderStateMixin {
  AnimationController _tutorialFadeInController;

  AnimationController _introEnterController;
  AnimationController _introExitController;

  AnimationController _firstPhaseController;
  AnimationController _secondPhaseController;
  AnimationController _thirdPhaseController;

  _FirstPhase _firstPhase;
  _SecondPhase _secondPhase;
  _ThirdPhase _thirdPhase;

  int _currentPhase = -1;
  bool _allowClipper = true;
  bool _allowButtonClick = true;

  @override
  void initState() {
    super.initState();

    _tutorialFadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _tutorialFadeInController.forward();
    _tutorialFadeInController.addStatusListener(_tutorialFadeInListener);

    _introEnterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _introExitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

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

  void _tutorialFadeInListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _tutorialFadeInController.removeStatusListener(_tutorialFadeInListener);
      _introEnterController.forward();
    }
  }

  @override
  void dispose() {
    _tutorialFadeInController.dispose();

    _introEnterController.dispose();
    _introExitController.dispose();

    _firstPhaseController.dispose();
    _secondPhaseController.dispose();
    _thirdPhaseController.dispose();

    super.dispose();
  }

  Future<void> _updatePhase(int phase) async {
    if (phase == 0) {
      if (_currentPhase == -1) {
        _introExitController.forward();
        _firstPhaseController.forward();
      } else {
        _secondPhaseController.reverse();
        _firstPhaseController.forward();
      }

      setState(() {
        _currentPhase = phase;
      });
    } else if (phase == 1) {
      if (_currentPhase == 0) {
        _firstPhaseController.reverse();
        setState(() {
          _allowClipper = false;
          _allowButtonClick = false;
        });
        await widget.weekScreenTutorialCallback.scrollToCheckPoints();
        _secondPhaseController.forward();

        setState(() {
          _allowClipper = true;
          _allowButtonClick = true;
          _currentPhase = phase;
        });
      } else {
        _thirdPhaseController.reverse();
        setState(() {
          _allowClipper = false;
          _allowButtonClick = false;
        });
        await widget.weekScreenTutorialCallback.scrollToCheckPoints();
        _secondPhaseController.forward();

        setState(() {
          _allowClipper = true;
          _allowButtonClick = true;
          _currentPhase = phase;
        });
      }
    } else if (phase == 2) {
      _secondPhaseController.reverse();
      setState(() {
        _allowClipper = false;
        _allowButtonClick = false;
      });
      await widget.weekScreenTutorialCallback.scrollToTodayPreview();
      _thirdPhaseController.forward();

      setState(() {
        _allowClipper = true;
        _allowButtonClick = true;
        _currentPhase = phase;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstPhase = _FirstPhase(
      controller: _firstPhaseController,
      headerFinder: widget.weekScreenTutorialCallback.getHeaderFinder(),
    );

    _secondPhase = _SecondPhase(
      controller: _secondPhaseController,
      checkPointsFinder: widget.weekScreenTutorialCallback.getCheckPointsFinder(),
    );

    _thirdPhase = _ThirdPhase(
      controller: _thirdPhaseController,
      todayPreviewFinder: widget.weekScreenTutorialCallback.getTodayPreviewFinder(),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                        parent: _introEnterController,
                        curve: Interval(0.9, 1.0),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _onNextClicked,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _currentPhase == -1 ? AppLocalizations.of(context).start
                                : _currentPhase < 2 ? AppLocalizations.of(context).next
                                : AppLocalizations.of(context).done,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _Intro(
                    enterController: _introEnterController,
                    exitController: _introExitController,
                  ),
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
    if (!_allowClipper) {
      return null;
    } else if (_currentPhase == 0) {
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
    if (_allowButtonClick) {
      _updatePhase(_currentPhase - 1);
    }
  }

  void _onNextClicked() {
    if (_allowButtonClick) {
      _updatePhase(_currentPhase + 1);
    }
  }
}

class _Intro extends StatelessWidget {
  final AnimationController enterController;
  final AnimationController exitController;

  _Intro({
    @required this.enterController,
    @required this.exitController,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0).animate(exitController),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.1)).animate(exitController),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: enterController,
                curve: Interval(0, 0.2, curve: Curves.ease),
              )),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).weekTutorialHi,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                parent: enterController,
                curve: Interval(0.5, 0.7, curve: Curves.ease),
              )),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).weekTutorialExplain,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                AppLocalizations.of(context).weekTutorialClickOrSwipe,
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
  final ViewLayoutInfo Function() checkPointsFinder;
  final _SecondPhaseClipper clipper;

  _SecondPhase({
    @required this.controller,
    @required this.checkPointsFinder,
  }): clipper = _SecondPhaseClipper(
    checkPointsFinder: checkPointsFinder,
  );

  @override
  Widget build(BuildContext context) {
    final checkPoints = checkPointsFinder();
    final checkPointsBottom = checkPoints.top + checkPoints.height;
    return Positioned(
      top: checkPointsBottom + 8,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(controller),
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(controller),
          child: Text(
            AppLocalizations.of(context).weekTutorialCheckPoints,
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
  final ViewLayoutInfo Function() checkPointsFinder;

  _SecondPhaseClipper({
    @required this.checkPointsFinder,
  });

  @override
  Path getClip(Size size) {
    final checkPoints = checkPointsFinder();
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(checkPoints.left, checkPoints.top, checkPoints.width, checkPoints.height),
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
  final ViewLayoutInfo Function() todayPreviewFinder;
  final _ThirdPhaseClipper clipper;

  _ThirdPhase({
    @required this.controller,
    @required this.todayPreviewFinder,
  }): clipper = _ThirdPhaseClipper(
    todayPreviewFinder: todayPreviewFinder,
  );

  @override
  State createState() => _ThirdPhaseState();
}

class _ThirdPhaseState extends State<_ThirdPhase> {
  double _myHeight = 0;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_updateMyHeight);

    final todayPreview = widget.todayPreviewFinder();
    return Positioned(
      top: todayPreview.top - _myHeight - 8,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(widget.controller),
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0))
            .animate(widget.controller),
          child: Text(
            AppLocalizations.of(context).weekTutorialDayPreview,
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
  final ViewLayoutInfo Function() todayPreviewFinder;

  _ThirdPhaseClipper({
    @required this.todayPreviewFinder,
  });

  @override
  Path getClip(Size size) {
    final todayPreview = todayPreviewFinder();
    final path = Path()
      ..addRect(Rect.fromLTWH(todayPreview.left, todayPreview.top, todayPreview.width, todayPreview.height))
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
