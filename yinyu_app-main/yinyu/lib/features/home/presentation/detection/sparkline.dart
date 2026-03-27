import 'package:flutter/material.dart';

class Sparkline extends StatelessWidget {
  final List<double> values;
  final double height;
  const Sparkline({super.key, required this.values, this.height = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _SparklinePainter(values, Theme.of(context).colorScheme.primary)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> v;
  final Color color;
  _SparklinePainter(this.v, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (v.isEmpty) return;

    final minV = v.reduce((a, b) => a < b ? a : b);
    final maxV = v.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 1e-9 ? 1.0 : (maxV - minV);

    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withOpacity(0.9);

    final path = Path();
    for (var i = 0; i < v.length; i++) {
      final x = size.width * (i / (v.length - 1));
      final yNorm = (v[i] - minV) / range;
      final y = size.height * (1 - yNorm);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // 背景网格
    final grid = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black.withOpacity(0.06);
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    canvas.drawPath(path, p);

    // 末端圆点
    final lastX = size.width;
    final lastYNorm = (v.last - minV) / range;
    final lastY = size.height * (1 - lastYNorm);
    canvas.drawCircle(Offset(lastX, lastY), 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.v != v || oldDelegate.color != color;
  }
}
