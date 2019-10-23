import 'package:flutter/material.dart';

class SlideUpPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpPageRoute({
    this.page,
    Duration duration = const Duration(milliseconds: 300),
  }): super(
    pageBuilder: (BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation) => page,
    transitionDuration: duration,
    transitionsBuilder: (BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.ease,
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        )),
        child: child,
      ),
    ),
  );
}
