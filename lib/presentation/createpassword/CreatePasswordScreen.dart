
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';

class CreatePasswordScreen extends StatefulWidget {
  @override
  State createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      alignment: Alignment.center,
      child: Text('CreatePasswordScreen'),
    );
  }

}