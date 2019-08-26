
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/Dependencies.dart';
import 'package:todo_app/presentation/App.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final dependencies = Dependencies();

  runApp(App(
    dependencies: dependencies,
  ));
}