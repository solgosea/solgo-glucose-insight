import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/cgm_sensor_signal_view_model.dart';
import 'cgm_signal_panel.dart';
import 'cgm_signal_shared.dart';

class CgmJumpSignalPanel extends StatelessWidget {
  static const _icon = Icons.bolt_rounded;

  final CgmSensorSignalViewModel signal;

  const CgmJumpSignalPanel({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    if (!signal.available) {
      return CgmSignalPanel(
        signal: signal,
        icon: _icon,
        visual: const CgmUnavailableVisual(icon: _icon),
      );
    }
    return CgmSignalPanel(
      signal: signal,
      icon: _icon,
      visual: LayoutBuilder(
        builder: (context, constraints) {
          final tight = constraints.maxHeight < 96;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: tight ? 34 : 46,
                child: CgmAnimatedValue(
                  value: 1,
                  builder: (context, grow) => CustomPaint(
                    painter: _JumpHistogramPainter(
                      positions: signal.eventPositions,
                      color: color,
                      grow: grow,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              SizedBox(height: tight ? 5 : 8),
              Text(
                '${signal.valueLabel} ${signal.valueLabel == '1' ? 'jump' : 'jumps'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StatusMonitorTheme.mono.copyWith(
                  color: color,
                  fontSize: tight ? 18 : 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: tight ? 4 : 6),
              const CgmScaleAxis(['24h', '12h', 'now']),
            ],
          );
        },
      ),
    );
  }
}

class _JumpHistogramPainter extends CustomPainter {
  static const _bins = 24; // one bar per hour over the trailing 24h

  final List<double> positions;
  final Color color;
  final double grow;

  const _JumpHistogramPainter({
    required this.positions,
    required this.color,
    required this.grow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseline = size.height - 2;

    if (positions.isEmpty) {
      canvas.drawLine(
        Offset(2, baseline),
        Offset(size.width - 2, baseline),
        Paint()
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = StatusMonitorTheme.green.withOpacity(.45),
      );
      final tick = Path()
        ..moveTo(size.width / 2 - 7, size.height / 2)
        ..lineTo(size.width / 2 - 2, size.height / 2 + 5)
        ..lineTo(size.width / 2 + 8, size.height / 2 - 6);
      canvas.drawPath(
        tick,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = StatusMonitorTheme.green.withOpacity(.7),
      );
      return;
    }

    final counts = List<int>.filled(_bins, 0);
    for (final position in positions) {
      final bin = (position.clamp(0, 1) * _bins).floor().clamp(0, _bins - 1);
      counts[bin]++;
    }
    final maxCount = counts.reduce((a, b) => a > b ? a : b);

    canvas.drawLine(
      Offset(2, baseline),
      Offset(size.width - 2, baseline),
      Paint()
        ..strokeWidth = 1
        ..color = StatusMonitorTheme.dim.withOpacity(.22),
    );

    const gap = 2.0;
    final barWidth = (size.width - gap * (_bins - 1)) / _bins;
    final maxBarHeight = size.height - 6;
    for (var i = 0; i < _bins; i++) {
      if (counts[i] == 0) continue;
      final height = maxBarHeight * (counts[i] / maxCount) * grow;
      final left = i * (barWidth + gap);
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, baseline - height, barWidth, height),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      );
      canvas.drawRRect(rect, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _JumpHistogramPainter oldDelegate) {
    return oldDelegate.positions != positions ||
        oldDelegate.color != color ||
        oldDelegate.grow != grow;
  }
}
