
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Dependencies.dart';
import 'package:todo_app/presentation/home/HomeScreen.dart';

// 앱 프로세스에 상주하는 static dependency injection
Dependencies _sharedDependencies;
Dependencies get dependencies => _sharedDependencies;

class App extends StatelessWidget {
  App({
    Key key,
    Dependencies dependencies,
  }): super(key: key) {
    _sharedDependencies = dependencies;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        splashColor: AppColors.ripple,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
