import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../foundation/theme/app_colors.dart';

class TirRingChart extends StatelessWidget {
  final double tir; // 0..100
  final double tar;
  final double tbr;
  final double size;

  const TirRingChart({
    super.key,
    required this.tir,
    required this.tar,
    required this.tbr,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TirRingPainter(tir: tir, tar: tar, tbr: tbr),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${tir.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
              const Text(
                'TIR',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 8,
                  color: AppColors.textDim,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TirRingPainter extends CustomPainter {
  final double tir, tar, tbr;
  _TirRingPainter({required this.tir, required this.tar, required this.tbr});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    const strokeWidth = 8.0;
    const startAngle = -pi / 2;

    final bgPaint =
        Paint()
          ..color = AppColors.bgCard2
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    void drawArc(double fraction, Color color, double offset) {
      if (fraction <= 0) return;
      final paint =
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + offset,
        fraction * 2 * pi - 0.04,
        false,
        paint,
      );
    }

    final tirF = tir / 100;
    final tarF = tar / 100;
    drawArc(tirF, AppColors.green, 0);
    drawArc(tarF, AppColors.rose, tirF * 2 * pi);
    drawArc(tbr / 100, AppColors.blue, (tirF + tarF) * 2 * pi);
  }

  @override
  bool shouldRepaint(_TirRingPainter old) =>
      old.tir != tir || old.tar != tar || old.tbr != tbr;
}
