import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/cgm_sensor_signal_view_model.dart';
import 'cgm_signal_panel.dart';
import 'cgm_signal_shared.dart';

class CgmSessionGauge extends StatelessWidget {
  static const _icon = Icons.timelapse_rounded;

  final CgmSensorSignalViewModel signal;

  const CgmSessionGauge({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    final remaining = (1 - signal.progress).clamp(0, 1).toDouble();
    return CgmSignalPanel(
      signal: signal,
      icon: _icon,
      visual: signal.available
          ? Center(
              child: AspectRatio(
                aspectRatio: 1.6,
                child: CgmAnimatedValue(
                  value: remaining,
                  builder: (context, animated) => CustomPaint(
                    painter: _SessionGaugePainter(
                      remaining: animated,
                      color: color,
                    ),
                    child: _center(color),
                  ),
                ),
              ),
            )
          : const CgmUnavailableVisual(icon: _icon),
    );
  }

  Widget _center(Color color) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            signal.valueLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'of 14d left',
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionGaugePainter extends CustomPainter {
  static const _segments = 14;
  static const _start = math.pi * .78;
  static const _sweep = math.pi * 1.44;

  final double remaining;
  final Color color;

  const _SessionGaugePainter({
    required this.remaining,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 8);
    final radius = math.min(size.width, size.height) * .38;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const gap = 0.06; // radians of spacing between day segments
    const span = (_sweep - gap * (_segments - 1)) / _segments;
    final litExact = remaining * _segments;

    for (var i = 0; i < _segments; i++) {
      final segStart = _start + i * (span + gap);
      final lit = (litExact - i).clamp(0.0, 1.0);
      canvas.drawArc(
        rect,
        segStart,
        span,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..color = StatusMonitorTheme.dim.withOpacity(.18),
      );
      if (lit <= 0) continue;
      canvas.drawArc(
        rect,
        segStart,
        span * lit,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SessionGaugePainter oldDelegate) {
    return oldDelegate.remaining != remaining || oldDelegate.color != color;
  }
}
