
import 'package:flutter/cupertino.dart';
import 'package:todo_app/Dependencies.dart';
import 'package:todo_app/presentation/App.dart';

void main() {
  final dependencies = Dependencies();

  runApp(App(
    dependencies: dependencies,
  ));
}