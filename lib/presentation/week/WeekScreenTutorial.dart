
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';

class WeekScreenTutorial extends StatefulWidget {
  final ViewLayoutInfo memoViewInfo;

  WeekScreenTutorial({
    @required this.memoViewInfo,
  });

  @override
  State createState() => _WeekScreenTutorialState();
}

class _WeekScreenTutorialState extends State<WeekScreenTutorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SCRIM,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: widget.memoViewInfo.left.toDouble(),
            top: widget.memoViewInfo.top.toDouble(),
            child: Text("hello",
              style: TextStyle(
                fontSize: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}