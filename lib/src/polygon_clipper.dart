import 'package:flutter/cupertino.dart';

import 'polygon_painter.dart';

class PolygonClipper extends CustomClipper<Path> {
  final PolygonPath path;

  PolygonClipper(this.path);

  @override
  Path getClip(Size size) {
    return path.getPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (oldClipper is PolygonClipper) {
      return oldClipper.path != path;
    }
    return true;
  }
}
