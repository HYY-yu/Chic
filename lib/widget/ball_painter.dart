import 'dart:math';

import 'package:chic/util/distance.dart';
import 'package:flutter/material.dart';

class Circle {
  double r;
  double a;
  double b;

  Circle(this.r, this.a, this.b);

  @override
  String toString() {
    return 'Circle{r: $r, a: $a, b: $b}';
  }
}

class CircleBuffer {
  static Circle ballBuffer;
}

class BallPainter extends CustomPainter {
  BallPainter(this.start, this.update, this.end, this.key);

  Offset start;
  Offset update;
  bool end;

  final GlobalKey key;
  final double radius = 40.0;
  Circle ball;

  void paint(Canvas canvas, Size size) {
    if (end) {
//      print("end paint");
      canvas.drawColor(Colors.transparent, BlendMode.dstOut);
      return;
    }

    if (CircleBuffer.ballBuffer == null) {
//      print("first paint");
      final ballContext = key.currentContext;
      if (ballContext != null) {
        final RenderBox box = ballContext.findRenderObject();
        final pos = box.localToGlobal(Offset.zero);

        // topLeft 变圆心
        ball = new Circle(box.size.width / 2.0, 0.0, 0.0);
        ball.a = pos.dx + ball.r;
        ball.b = pos.dy + ball.r;

        // 缓存
        CircleBuffer.ballBuffer = ball;
      }
    } else {
      ball = CircleBuffer.ballBuffer;
    }

    var paint = new Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    if (update == null) {
      return;
    }

    canvas.drawColor(Colors.black38, BlendMode.dstOut);
    canvas.drawCircle(update, radius, paint);
    canvas.drawCircle(new Offset(ball.a, ball.b), ball.r, paint);

    Circle smallBall = new Circle(radius, update.dx, update.dy);
    double distance = DistanceUtil.getDistance(ball.a, ball.b, smallBall.a, smallBall.b);

    metaball(canvas, paint, smallBall, ball, 0.5, 8.0, ball.r * 1.5, distance);
  }

  void metaball(
      Canvas canvas,
      Paint paint,
      Circle ball1,
      Circle ball2,
      double v,
      double handleLenRate,
      double maxDistance,
      double distanceForTwoCircle) {
    double radius1 = ball1.r;
    double radius2 = ball2.r;

    double pi_2 = (pi / 2);
    double u1 = 0.0;
    double u2 = 0.0;

    if (radius1 == 0 || radius2 == 0) {
      return;
    }

    //如果两圆距离大于可以绘制曲线的程度或者小圆完全被大圆包裹，就不用绘制曲线了。
    if (distanceForTwoCircle > maxDistance ||
        distanceForTwoCircle <= (radius1 - radius2).abs()) {
      return;
    }

    if (distanceForTwoCircle < radius1 + radius2) {
      u1 = acos((radius1 * radius1 +
              distanceForTwoCircle * distanceForTwoCircle -
              radius2 * radius2) /
          (2 * radius1 * distanceForTwoCircle));
      u2 = acos((radius2 * radius2 +
              distanceForTwoCircle * distanceForTwoCircle -
              radius1 * radius1) /
          (2 * radius2 * distanceForTwoCircle));
    }

    var centermin = new List<double>();
    centermin.add(ball2.a - ball1.a);
    centermin.add(ball2.b - ball1.b);

    double angle1 = atan2(centermin[1], centermin[0]);
    double angle2 = acos((radius1 - radius2) / distanceForTwoCircle);
    double angle1a = angle1 + u1 + (angle2 - u1) * v;
    double angle1b = angle1 - u1 - (angle2 - u1) * v;
    double angle2a = (angle1 + pi - u2 - (pi - u2 - angle2) * v);
    double angle2b = (angle1 - pi + u2 + (pi - u2 - angle2) * v);

    List<double> p1a1 = DistanceUtil.getVector(angle1a, radius1);
    List<double> p1b1 = DistanceUtil.getVector(angle1b, radius1);
    List<double> p2a1 = DistanceUtil.getVector(angle2a, radius2);
    List<double> p2b1 = DistanceUtil.getVector(angle2b, radius2);

    List<double> p1a = [p1a1[0] + ball1.a, p1a1[1] + ball1.b];
    List<double> p1b = [p1b1[0] + ball1.a, p1b1[1] + ball1.b];
    List<double> p2a = [p2a1[0] + ball2.a, p2a1[1] + ball2.b];
    List<double> p2b = [p2b1[0] + ball2.a, p2b1[1] + ball2.b];

    List<double> p1_p2 = [p1a[0] - p2a[0], p1a[1] - p2a[1]];

    double totalRadius = (radius1 + radius2);
    double d2 = min(v * handleLenRate,
        DistanceUtil.getLength(p1_p2[0], p1_p2[1]) / totalRadius);
    d2 *= min(1, distanceForTwoCircle * 2 / (radius1 + radius2));

    radius1 *= d2;
    radius2 *= d2;

    List<double> sp1 = DistanceUtil.getVector(angle1a - pi_2, radius1);
    List<double> sp2 = DistanceUtil.getVector(angle2a + pi_2, radius2);
    List<double> sp3 = DistanceUtil.getVector(angle2b - pi_2, radius2);
    List<double> sp4 = DistanceUtil.getVector(angle1b + pi_2, radius1);

    Path path1 = new Path();
    path1.moveTo(p1a[0], p1a[1]);
    path1.cubicTo(p1a[0] + sp1[0], p1a[1] + sp1[1], p2a[0] + sp2[0],
        p2a[1] + sp2[1], p2a[0], p2a[1]);
    path1.lineTo(p2b[0], p2b[1]);
    path1.cubicTo(p2b[0] + sp3[0], p2b[1] + sp3[1], p1b[0] + sp4[0],
        p1b[1] + sp4[1], p1b[0], p1b[1]);
    path1.lineTo(p1a[0], p1a[1]);
    path1.close();

    canvas.drawPath(path1, paint);
  }

  bool shouldRepaint(BallPainter other) => other.update != update;
}
