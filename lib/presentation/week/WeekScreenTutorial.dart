
import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';
import 'package:todo_app/presentation/week/WeekScreenViewFinders.dart';

class WeekScreenTutorial extends StatefulWidget {
  final WeekScreenViewFinders weekScreenViewFinders;

  WeekScreenTutorial({
    @required this.weekScreenViewFinders,
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

  _FirstPhase _firstPhase;

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

    _introEnterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _introExitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _firstPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _secondPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
    super.dispose();

    _tutorialFadeInController.dispose();

    _introEnterController.dispose();
    _introExitController.dispose();

    _firstPhaseController.dispose();
    _secondPhaseController.dispose();
  }

  void _updatePhase(int phase) {
    if (phase == 0) {
      if (_currentPhase == -1) {
        _introExitController.forward();
        _firstPhaseController.forward();
      } else {
        _secondPhaseController.reverse();
        _firstPhaseController.forward();
      }
      _firstPhaseController.addStatusListener(_firstPhaseStatusListener);
    }
  }

  void _firstPhaseStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _firstPhaseController.removeStatusListener(_firstPhaseStatusListener);
      // set state after animation has finished for more fluent UI
      setState(() {
        _currentPhase = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstPhase = _FirstPhase(
      controller: _firstPhaseController,
      prevIconFinder: widget.weekScreenViewFinders.getPrevIconFinder(),
      nextIconFinder: widget.weekScreenViewFinders.getNextIconFinder(),
      onNextClicked: () => _updatePhase(1),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeTransition(
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
              children: <Widget>[
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(_secondPhaseController),
                  child: Align(
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
                  ),
                ),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(_firstPhaseController),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: _Dots(
                        currentPhase: _currentPhase,
                      ),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(_firstPhaseController),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _onNextClicked,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            AppLocalizations.of(context).next,
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
                  onStartClicked: () => _updatePhase(0),
                ),
                _firstPhase,

              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomClipper _getClipper() {
    if (_currentPhase == 0) {
      return _firstPhase.clipper;
    } else {
      return null;
    }
  }

  void _onPrevClicked() {

  }

  void _onNextClicked() {

  }
}

class _Intro extends StatelessWidget {
  final AnimationController enterController;
  final AnimationController exitController;
  final void Function() onStartClicked;

  _Intro({
    @required this.enterController,
    @required this.exitController,
    @required this.onStartClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(exitController),
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.2)).animate(exitController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: enterController,
                    curve: Interval(0, 0.1, curve: Curves.ease),
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
                    curve: Interval(0.3, 0.4, curve: Curves.ease),
                  )),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).weekTutorialFirstTime,
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
                    curve: Interval(0.6, 0.7, curve: Curves.ease),
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
        ),
        FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(exitController),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: enterController,
              curve: Interval(0.9, 1.0, curve: Curves.ease),
            )),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onStartClicked,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      AppLocalizations.of(context).start,
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
        ),
      ],
    );
  }
}

class _FirstPhase extends StatelessWidget {
  final AnimationController controller;
  final ViewLayoutInfo Function() prevIconFinder;
  final ViewLayoutInfo Function() nextIconFinder;
  final void Function() onNextClicked;
  final _FirstPhaseClipper clipper;

  _FirstPhase({
    Key key,
    @required this.controller,
    @required this.prevIconFinder,
    @required this.nextIconFinder,
    @required this.onNextClicked,
  }): clipper = _FirstPhaseClipper(
    prevIconFinder: prevIconFinder,
    nextIconFinder: nextIconFinder,
  ), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(controller),
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(0, 0.2), end: Offset(0, 0)).animate(controller),
            child: Center(
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
  final ViewLayoutInfo Function() prevIconFinder;
  final ViewLayoutInfo Function() nextIconFinder;

  _FirstPhaseClipper({
    @required this.prevIconFinder,
    @required this.nextIconFinder,
  });

  @override
  Path getClip(Size size) {
    final prevIcon = prevIconFinder();
    final nextIcon = nextIconFinder();
    final path = Path()
      ..addOval(Rect.fromLTWH(prevIcon.left, prevIcon.top, prevIcon.width, prevIcon.height))
      ..addOval(Rect.fromLTWH(nextIcon.left, nextIcon.top, nextIcon.width, nextIcon.height))
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
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