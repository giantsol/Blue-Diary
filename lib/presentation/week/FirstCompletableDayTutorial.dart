
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';
import 'package:todo_app/presentation/week/WeekScreenTutorialCallback.dart';

class FirstCompletableDayTutorial extends StatefulWidget {
  final WeekScreenTutorialCallback weekScreenTutorialCallback;

  FirstCompletableDayTutorial({
    @required this.weekScreenTutorialCallback,
  });

  @override
  State createState() => _FirstCompletableDayTutorialState();
}

class _FirstCompletableDayTutorialState extends State<FirstCompletableDayTutorial> with TickerProviderStateMixin {
  AnimationController _tutorialFadeInController;

  AnimationController _firstPhaseController;
  _FirstPhase _firstPhase;

  int _currentPhase = -1;
  bool _allowClipper = false;
  bool _allowButtonClick = false;

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
  }

  @override
  void dispose() {
    _tutorialFadeInController.dispose();
    _firstPhaseController.dispose();

    super.dispose();
  }

  void _tutorialFadeInListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _tutorialFadeInController.removeStatusListener(_tutorialFadeInListener);
      _updatePhase(_currentPhase + 1);
    }
  }

  Future<void> _updatePhase(int phase) async {
    if (phase == 0) {
      await widget.weekScreenTutorialCallback.scrollToFirstCompletableDayThumbnail();
      _firstPhaseController.forward();

      setState(() {
        _allowClipper = true;
        _allowButtonClick = true;
        _currentPhase = phase;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstPhase = _FirstPhase(
      controller: _firstPhaseController,
      firstCompletableDayThumbnailFinder: widget.weekScreenTutorialCallback.getFirstCompletableDayThumbnailFinder(),
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
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                        parent: _firstPhaseController,
                        curve: Interval(0.9, 1.0),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _onOkClicked,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              AppLocalizations.of(context).ok,
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
                  _firstPhase,
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
    } else {
      return null;
    }
  }

  void _onOkClicked() {
    if (_allowButtonClick) {
      _updatePhase(_currentPhase + 1);
    }
  }
}

class _FirstPhase extends StatefulWidget {
  final AnimationController controller;
  final ViewLayoutInfo Function() firstCompletableDayThumbnailFinder;
  final _FirstPhaseClipper clipper;

  _FirstPhase({
    @required this.controller,
    @required this.firstCompletableDayThumbnailFinder,
  }): clipper = _FirstPhaseClipper(
    firstCompletableDayThumbnailFinder: firstCompletableDayThumbnailFinder,
  );

  @override
  State createState() => _FirstPhaseState();
}

class _FirstPhaseState extends State<_FirstPhase> {
  double _myHeight = 0;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_updateMyHeight);

    final dayThumbnail = widget.firstCompletableDayThumbnailFinder();
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(widget.controller),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(widget.controller),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).firstCompletableDayTutorial,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8,),
            Text(
              AppLocalizations.of(context).firstCompletableDayTutorialSub,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: max<double>(_myHeight - dayThumbnail.top + 8, 0),),
          ],
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

class _FirstPhaseClipper extends CustomClipper<Path> {
  final ViewLayoutInfo Function() firstCompletableDayThumbnailFinder;

  _FirstPhaseClipper({
    @required this.firstCompletableDayThumbnailFinder,
  });

  @override
  Path getClip(Size size) {
    final view = firstCompletableDayThumbnailFinder();
    final path = Path()
      ..addOval(Rect.fromLTWH(view.left, view.top, view.width, view.height))
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
