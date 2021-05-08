import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class PolygonPath {
  final int sides;
  final double rotate;
  final double borderRadius;

  PolygonPath({required this.sides, this.rotate = 0.0, this.borderRadius = 0});

  getPath(Size size) {
    final anglePerSide = (math.pi * 2) / sides;
    // print('angelPerSide: ${anglePerSide / (math.pi * 2) * 360}');

    final startAngle = rotate % (2 * math.pi);

    final radius = size.shortestSide / 2;

    final sideLength = 2 * radius * math.sin(math.pi / sides);

    final halfSideLength = sideLength / 2;
    // print('halfSideLength $halfSideLength');

    final interiorAngle = (sides - 2) * math.pi / sides;
    // print('interiorAngle $interiorAngle');
    // print(interiorAngle / 2);

    final innerCircleRadius = sideLength / (2 * math.tan(math.pi / sides));
    // print('innerCircleRadius $innerCircleRadius');

    final _borderRadius =
        borderRadius > innerCircleRadius ? innerCircleRadius : borderRadius;

    var sidePart = _borderRadius / math.tan(interiorAngle / 2);
    // print('sidePart $sidePart');

    if (sidePart > halfSideLength) {
      sidePart = halfSideLength;
    }
    // print('sidePart after check $sidePart');

    final sweepAngle = math.atan((sidePart * math.sin(interiorAngle / 2)) /
        ((radius - sidePart * math.cos(interiorAngle / 2))));

    final sweepRadius = math.sqrt(math.pow(innerCircleRadius, 2) +
        math.pow(halfSideLength - sidePart, 2));

    // print(sidePart * math.cos(interiorAngle));
    // print(math.sin(sweepAngle));
    // print(sweepRadius);

    final polygonPath = Path();

    ///WTF WARNING
    ///USE [sides+1] because at border drawing is skip dot
    ///
    for (var i = 0; i <= sides ; i++) {
      double currentAngle = anglePerSide * i + startAngle;
      double xl = radius + sweepRadius * math.cos(currentAngle - sweepAngle);
      double yl = radius + sweepRadius * math.sin(currentAngle - sweepAngle);
      double xr = radius + sweepRadius * math.cos(currentAngle + sweepAngle);
      double yr = radius + sweepRadius * math.sin(currentAngle + sweepAngle);
      if (i == 0) {
        polygonPath.moveTo(xl, yl);
      } else {
        polygonPath.lineTo(xl, yl);
      }
      if (_borderRadius > 0) {
        polygonPath.arcToPoint(Offset(xr, yr),
            radius: Radius.circular(_borderRadius));
      }
    }
    return polygonPath;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolygonPath &&
          sides == other.sides &&
          rotate == other.rotate &&
          borderRadius == other.borderRadius;

  @override
  int get hashCode => sides.hashCode ^ rotate.hashCode ^ borderRadius.hashCode;
}

class PolygonPainter extends CustomPainter {
  PolygonPainter({
    this.color,
    required this.sides,
    this.rotateAngle = 0.0,
  }) : _paint = Paint()
          ..color = color ?? const Color(0xFF000000)
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  final int sides;
  final Color? color;
  final double rotateAngle;

  final Paint _paint;

  final _borderRadius = 50.0;

  @override
  void paint(Canvas canvas, Size size) {
    // var path = createPath(sides, size.width / 2, rotateAngle);
    // path = Path.combine(
    //     PathOperation.intersect,
    //     path,
    //     Path()
    //       ..addOval((Rect.fromCircle(
    //         center: Offset(0, 0),
    //         radius: size.width / 2 - 2,
    //       ))));

    final anglePerSide = (math.pi * 2) / sides;
    final startAngle = rotateAngle % (2 * math.pi);

    final radius = (size.width) / 2;
    final List<Offset> points = [];
    for (var i = 0; i <= sides; i++) {
      double currentAngle = anglePerSide * i + startAngle;
      double x = radius + (radius) * math.cos(currentAngle);
      double y = radius + (radius) * math.sin(currentAngle);
      points.add(Offset(x, y));
    }

    var path2 = Path()..addPolygon(points, true);
    print(points);
    // canvas.drawPath(path, _paint);

    canvas.drawPath(path2, _paint..color = Colors.red);
    // canvas.drawShadow(path, Colors.black, 0, false);

    // canvas.drawPath(
    //     Path()
    //       ..addOval(Rect.fromCircle(
    //           center: Offset(radius, radius),
    //           radius: radius - (_borderRadius / 2) * math.cos(anglePerSide))),
    //     _paint..color = Colors.yellowAccent);
    final sideLength = 2 * radius * math.sin(math.pi / sides);
    final halfSideLength = sideLength / 2;
    print('angelPerSide: ${anglePerSide / (math.pi * 2) * 360}');
    print('halfSideLength $halfSideLength');
    final interiorAngle = (sides - 2) * math.pi / sides;
    final innerCircleRadius = sideLength / (2 * math.tan(math.pi / sides));
    print('interiorAngle $interiorAngle');
    print('innerCircleRadius $innerCircleRadius');
    print(interiorAngle / 2);
    print(math.tan(interiorAngle / 2));
    var sidePart = _borderRadius / math.tan(interiorAngle / 2);
    print('sidePart $sidePart');
    if (sidePart > halfSideLength) {
      sidePart = halfSideLength;
    }
    final List<Offset> testPoints = [];
    final sweepAngle = math.atan((sidePart * math.sin(interiorAngle / 2)) /
        ((radius - sidePart * math.cos(interiorAngle / 2))));
    // final sweepRadius = (radius - sidePart * math.cos(interiorAngle / 2));
    final sweepRadius = math.sqrt(math.pow(innerCircleRadius, 2) +
        math.pow(halfSideLength - sidePart, 2));
    // math.sin(sweepAngle%(math.pi/4));
    print(sidePart * math.cos(interiorAngle));
    print(math.sin(sweepAngle));
    print(sweepRadius);

    // print(temp);
    final customPath = Path();
    for (var i = 0; i <= sides; i++) {
      double currentAngle = anglePerSide * i + startAngle;
      double xl = radius + sweepRadius * math.cos(currentAngle - sweepAngle);
      double yl = radius + sweepRadius * math.sin(currentAngle - sweepAngle);
      double xr = radius + sweepRadius * math.cos(currentAngle + sweepAngle);
      double yr = radius + sweepRadius * math.sin(currentAngle + sweepAngle);
      if (i == 0) {
        customPath.moveTo(xl, yl);
      } else {
        customPath.lineTo(xl, yl);
      }
      // customPath.moveTo(xr, yr);
      customPath.arcToPoint(Offset(xr, yr),
          radius: Radius.circular(_borderRadius));
      var circleCenter = Offset(
          radius +
              (radius - _borderRadius / (math.sin(interiorAngle / 2))) *
                  math.cos(currentAngle),
          radius +
              (radius - _borderRadius / (math.sin(interiorAngle / 2))) *
                  math.sin(currentAngle));
      canvas.drawCircle(
          circleCenter, _borderRadius, _paint..color = Colors.yellowAccent);
      testPoints.add(Offset(xl, yl));
      testPoints.add(Offset(xr, yr));
      testPoints.add(circleCenter);
    }
    canvas.drawPath(customPath, _paint..color = Colors.black45);
    canvas.drawPoints(
        PointMode.points, testPoints, _paint..color = Colors.blue);
    //
    // if (showDots) {
    //   try {
    //     var metric = extractPath.computeMetrics().first;
    //     final offset = metric.getTangentForOffset(metric.length)!.position;
    //     canvas.drawCircle(offset, 8.0, Paint());
    //   } catch (e) {}
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
