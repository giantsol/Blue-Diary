
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/presentation/home/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final curve = CurvedAnimation(parent: _animationController, curve: Curves.ease);
    _animation = Tween(begin: 1.0, end: 0.0).animate(curve);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _startAnimationThenNavigate(context);
    return Container(
      color: AppColors.BACKGROUND_WHITE,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _animation,
        child: Image.asset('assets/ic_lock_logo.png')
      ),
    );
  }

  Future<void> _startAnimationThenNavigate(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _animationController.forward();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
