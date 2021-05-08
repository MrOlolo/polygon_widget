import 'package:flutter/rendering.dart';
import 'package:polygon_widget/src/polygon_border.dart';

class PolygonDecoration {
  final Color? color;
  final PolygonBorder? border;
  final double? borderRadius;
  final List<BoxShadow>? boxShadows;

  PolygonDecoration(
      {this.color, this.border, this.borderRadius, this.boxShadows});
}
