import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/cgm_sensor_signal_view_model.dart';
import 'cgm_signal_panel.dart';
import 'cgm_signal_shared.dart';

class CgmVariabilityGauge extends StatelessWidget {
  static const _icon = Icons.show_chart_rounded;

  final CgmSensorSignalViewModel signal;

  const CgmVariabilityGauge({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    return CgmSignalPanel(
      signal: signal,
      icon: _icon,
      visual: signal.available
          ? Column(
              children: [
                Expanded(
                  child: CgmAnimatedValue(
                    value: signal.progress,
                    builder: (context, animated) => CustomPaint(
                      painter: _VariabilityGaugePainter(
                        progress: animated,
                        needle: color,
                      ),
                      child: Align(
                        alignment: const Alignment(0, .28),
                        child: Text(
                          signal.valueLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StatusMonitorTheme.mono.copyWith(
                            color: color,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const CgmZoneLegend(
                  low: 'Stable',
                  mid: 'Elevated',
                  high: 'High',
                ),
              ],
            )
          : const CgmUnavailableVisual(icon: _icon),
    );
  }
}

class _VariabilityGaugePainter extends CustomPainter {
  final double progress;
  final Color needle;

  const _VariabilityGaugePainter({
    required this.progress,
    required this.needle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .86);
    final radius = math.min(size.width * .42, size.height * .86);
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = math.pi;
    const sweep = math.pi;

    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round
        ..color = StatusMonitorTheme.dim.withOpacity(.16),
    );
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: math.pi,
          endAngle: math.pi * 2,
          colors: [
            StatusMonitorTheme.green,
            StatusMonitorTheme.amber,
            StatusMonitorTheme.rose,
          ],
        ).createShader(rect),
    );

    _endLabel(canvas, '0%', Offset(center.dx - radius, center.dy + 12));
    _endLabel(canvas, '60%', Offset(center.dx + radius, center.dy + 12));

    final angle = start + sweep * progress.clamp(0, 1);
    final tip = Offset(
      center.dx + math.cos(angle) * (radius - 4),
      center.dy + math.sin(angle) * (radius - 4),
    );
    final normal = Offset(-math.sin(angle), math.cos(angle));
    final baseA = center + normal * 5;
    final baseB = center - normal * 5;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(baseA.dx, baseA.dy)
      ..lineTo(baseB.dx, baseB.dy)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeJoin = StrokeJoin.round
        ..color = StatusMonitorTheme.bg,
    );
    canvas.drawPath(path, Paint()..color = needle);
    canvas.drawCircle(center, 6, Paint()..color = StatusMonitorTheme.bg);
    canvas.drawCircle(center, 3.5, Paint()..color = needle);
  }

  void _endLabel(Canvas canvas, String text, Offset anchor) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: StatusMonitorTheme.mono.copyWith(
          color: StatusMonitorTheme.dim,
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(anchor.dx - tp.width / 2, anchor.dy));
  }

  @override
  bool shouldRepaint(covariant _VariabilityGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.needle != needle;
  }
}
