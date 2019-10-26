
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preference_service.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Dependencies.dart';
import 'package:todo_app/presentation/App.dart';

Future<void> main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.BACKGROUND_WHITE,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  final dependencies = Dependencies();

  await PrefService.init();

  runApp(App(
    dependencies: dependencies,
  ));
}