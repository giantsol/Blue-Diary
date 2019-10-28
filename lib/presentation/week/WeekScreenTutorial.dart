
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
  AnimationController _introController;
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

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _introController.reverseDuration = const Duration(milliseconds: 500);

    _firstPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _secondPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  void _tutorialFadeInListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _tutorialFadeInController.removeStatusListener(_tutorialFadeInListener);
      _introController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _tutorialFadeInController.dispose();
    _introController.dispose();
    _firstPhaseController.dispose();
    _secondPhaseController.dispose();
  }

  void _updatePhase(int phase) {
    if (phase == 0) {
      if (_currentPhase == -1) {
        _introController.reverse();
        _firstPhaseController.forward();
      } else {
        _secondPhaseController.reverse();
        _firstPhaseController.forward();
      }
    }

    setState(() {
      _currentPhase = phase;
    });
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
                _Intro(
                  controller: _introController,
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
}

class _Intro extends StatelessWidget {
  final AnimationController controller;
  final void Function() onStartClicked;

  _Intro({
    @required this.controller,
    @required this.onStartClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: controller,
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
                parent: controller,
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
                parent: controller,
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
        FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: controller,
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
    return Container();
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