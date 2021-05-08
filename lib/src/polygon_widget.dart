import 'package:flutter/material.dart';
import 'package:polygon_widget/src/polygon_border.dart';
import 'package:polygon_widget/src/polygon_clipper.dart';
import 'package:polygon_widget/src/polygon_decoration.dart';
import 'package:polygon_widget/src/polygon_painter.dart';

class PolygonWidget extends StatelessWidget {
  final int sidesAmount;
  final Widget? child;
  final Color? color;
  final double rotate;
  final PolygonDecoration? decoration;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final double? radius;

  const PolygonWidget(
      {Key? key,
      this.sidesAmount = 3,
      this.child,
      this.rotate = 0.0,
      this.decoration,
      this.alignment,
      this.margin,
      this.color,
      this.radius})
      : assert(sidesAmount > 2),
        assert(
            color == null || decoration == null,
            'Cannot provide both a color and a decoration\n'
            'To provide both, use "decoration: PolygonDecoration(color: color)".'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? current = child;

    if (child == null) {
      current = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    }
    if (alignment != null)
      current = Align(alignment: alignment!, child: current);

    if (color != null) current = ColoredBox(color: color!, child: current);

    final borderRadius =
        decoration?.border?.borderRadius ?? (decoration?.borderRadius ?? 0.0);
    final path = PolygonPath(
        sides: sidesAmount, rotate: rotate, borderRadius: borderRadius);
    current = AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: ShapeDecoration(
            shadows: decoration?.boxShadows,
            color: decoration?.color,
            shape: PolygonBorder(
                sides: sidesAmount,
                borderRadius: borderRadius,
                rotate: rotate,
                border: decoration?.border?.border ?? BorderSide.none)),
        child: ClipPath(
          clipper: PolygonClipper(path),
          child: current,
        ),
      ),
    );
    if (radius != null) {
      current = SizedBox.fromSize(
        size: Size.fromRadius(radius!),
        child: current,
      );
    }

    if (margin != null) current = Padding(padding: margin!, child: current);

    return current;
  }
}
