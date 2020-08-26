
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preference_service.dart';
import 'package:todo_app/Dependencies.dart';
import 'package:todo_app/presentation/App.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // need to create Dependencies after initializations are completed.
  await PrefService.init();
  await Firebase.initializeApp();

  final dependencies = Dependencies();

  runApp(App(
    dependencies: dependencies,
  ));
}