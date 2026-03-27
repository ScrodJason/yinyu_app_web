import 'dart:math';

class RandomUtils {
  static final _r = Random();

  static double nextDouble(double min, double max) => min + _r.nextDouble() * (max - min);

  static T pick<T>(List<T> items) => items[_r.nextInt(items.length)];

  static List<double> sparkline({int n = 24, double min = 0.1, double max = 0.9}) {
    final res = <double>[];
    var v = nextDouble(min, max);
    for (var i = 0; i < n; i++) {
      v += nextDouble(-0.08, 0.08);
      if (v < min) v = min;
      if (v > max) v = max;
      res.add(v);
    }
    return res;
  }
}
