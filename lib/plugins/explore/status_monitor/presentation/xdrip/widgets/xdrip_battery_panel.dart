import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/xdrip_signal_view_model.dart';
import 'xdrip_signal_panel.dart';
import 'xdrip_signal_shared.dart';

class XdripBatteryPanel extends StatelessWidget {
  static const _icon = Icons.battery_charging_full_rounded;

  final XdripSignalViewModel signal;

  const XdripBatteryPanel({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    if (!signal.available) {
      return XdripSignalPanel(
        signal: signal,
        icon: _icon,
        visual: const XdripUnavailableVisual(icon: _icon),
      );
    }
    return XdripSignalPanel(
      signal: signal,
      icon: _icon,
      visual: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: XdripAnimatedValue(
              value: signal.progress,
              builder: (context, animated) => CustomPaint(
                painter: _BatteryPainter(progress: animated, color: color),
                child: Center(
                  child: Text(
                    signal.valueLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StatusMonitorTheme.mono.copyWith(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const XdripScaleAxis(['0%', '50%', '100%']),
        ],
      ),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  static const _lowFraction = 0.20; // low-battery reference line

  final double progress;
  final Color color;

  const _BatteryPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .16,
        size.height * .24,
        size.width * .62,
        size.height * .50,
      ),
      const Radius.circular(9),
    );
    final cap = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .79,
        size.height * .39,
        size.width * .06,
        size.height * .20,
      ),
      const Radius.circular(3),
    );

    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = StatusMonitorTheme.dim.withOpacity(.32),
    );
    canvas.drawRRect(
        cap, Paint()..color = StatusMonitorTheme.dim.withOpacity(.22));

    final inner = body.outerRect.deflate(5);
    final ratio = progress.clamp(0, 1).toDouble();
    final fillWidth = ratio <= 0
        ? 0.0
        : math.max(inner.width * ratio, 6.0).clamp(0.0, inner.width);
    if (fillWidth > 0) {
      final fill = Rect.fromLTWH(
        inner.left,
        inner.top,
        fillWidth.toDouble(),
        inner.height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(fill, const Radius.circular(5)),
        Paint()..color = color.withOpacity(.82),
      );
    }

    final notchX = inner.left + inner.width * _lowFraction;
    canvas.drawLine(
      Offset(notchX, inner.top + 1),
      Offset(notchX, inner.bottom - 1),
      Paint()
        ..strokeWidth = 1.4
        ..color = StatusMonitorTheme.rose.withOpacity(.55),
    );
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
