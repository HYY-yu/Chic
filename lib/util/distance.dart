import 'dart:math';

class DistanceUtil {
  static double getDistance(
      final double x1, final double y1, final double x2, final double y2) {
    double x = x1 - x2;
    double y = y1 - y2;
    double d = x * x + y * y;
    return sqrt(d).abs();
  }

  static double getLength(double x, double y) {
    return getDistance(x, y, 0.0, 0.0);
  }

  static List<double> getVector(double radians, double length) {
    var result = new List<double>();
    result.add((cos(radians) * length));
    result.add((sin(radians) * length));
    return result;
  }
}
