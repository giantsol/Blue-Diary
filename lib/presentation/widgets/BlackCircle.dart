
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlackCircle extends StatelessWidget {
  final int size;

  const BlackCircle({
    Key key,
    @required this.size
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BlackCirclePainter(size));
  }
}

class _BlackCirclePainter extends CustomPainter {
  final int size;
  final _paint;

  _BlackCirclePainter(this.size):
      _paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0, 0), this.size / 2, _paint);
  }

}