
import 'package:flutter/material.dart';

class ViewLayoutInfo {
  static ViewLayoutInfo create(RenderBox renderBox, {
    Offset offset = Offset.zero,
  }) {
    if (renderBox == null) {
      return ViewLayoutInfo(
        left: 0,
        top: 0,
        width: 0,
        height: 0,
      );
    } else {
      final position = renderBox.localToGlobal(offset);
      final size = renderBox.size;
      return ViewLayoutInfo(
        left: position.dx,
        top: position.dy,
        width: size.width,
        height: size.height,
      );
    }
  }

  final double left;
  final double top;
  final double width;
  final double height;

  bool get isValid => left != 0 && top != 0 && width != 0 && height != 0;
  double get right => left + width;
  double get bottom => top + height;

  const ViewLayoutInfo({
    @required this.left,
    @required this.top,
    @required this.width,
    @required this.height,
  });

  @override
  String toString() {
    return 'ViewLayoutInfo(left: $left, top: $top, width: $width, height: $height)';
  }
}