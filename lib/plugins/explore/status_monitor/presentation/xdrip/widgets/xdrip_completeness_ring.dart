import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/xdrip_signal_view_model.dart';
import 'xdrip_signal_panel.dart';
import 'xdrip_signal_shared.dart';

class XdripCompletenessRing extends StatelessWidget {
  static const _icon = Icons.checklist_rtl_rounded;

  static const _targetFraction = 0.95;

  final XdripSignalViewModel signal;

  const XdripCompletenessRing({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    return XdripSignalPanel(
      signal: signal,
      icon: _icon,
      visual: signal.available
          ? Center(
              child: AspectRatio(
                aspectRatio: 1.62,
                child: XdripAnimatedValue(
                  value: signal.progress,
                  builder: (context, animated) => CustomPaint(
                    painter: _CompletenessSegmentPainter(
                      progress: animated,
                      color: color,
                      targetFraction: _targetFraction,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            signal.valueLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: StatusMonitorTheme.mono.copyWith(
                              color: color,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'captured',
                            style: StatusMonitorTheme.mono.copyWith(
                              color: StatusMonitorTheme.dim,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const XdripUnavailableVisual(icon: _icon),
    );
  }
}

class _CompletenessSegmentPainter extends CustomPainter {
  static const _segments = 24; // one tick per hour over the trailing 24h
  static const _start = -math.pi / 2;
  static const _full = math.pi * 2;
  static const _gap = 0.10; // radians between hour ticks

  final double progress;
  final Color color;
  final double targetFraction;

  const _CompletenessSegmentPainter({
    required this.progress,
    required this.color,
    required this.targetFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .34;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const span = (_full - _gap * _segments) / _segments;
    final litExact = progress.clamp(0, 1) * _segments;

    for (var i = 0; i < _segments; i++) {
      final segStart = _start + i * (span + _gap);
      canvas.drawArc(
        rect,
        segStart,
        span,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..color = StatusMonitorTheme.dim.withOpacity(.16),
      );
      final lit = (litExact - i).clamp(0.0, 1.0);
      if (lit <= 0) continue;
      canvas.drawArc(
        rect,
        segStart,
        span * lit,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }

    final angle = _start + _full * targetFraction;
    final inner = Offset(
      center.dx + math.cos(angle) * (radius - 8),
      center.dy + math.sin(angle) * (radius - 8),
    );
    final outer = Offset(
      center.dx + math.cos(angle) * (radius + 8),
      center.dy + math.sin(angle) * (radius + 8),
    );
    canvas.drawLine(
      inner,
      outer,
      Paint()
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = StatusMonitorTheme.text.withOpacity(.55),
    );
  }

  @override
  bool shouldRepaint(covariant _CompletenessSegmentPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.targetFraction != targetFraction;
  }
}
