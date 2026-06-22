import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/nightscout_signal_view_model.dart';
import 'nightscout_signal_panel.dart';
import 'nightscout_signal_shared.dart';

class NightscoutDeviceStatusPanel extends StatelessWidget {
  static const _icon = Icons.hub_rounded;

  static const _cap = 14;

  final NightscoutSignalViewModel signal;

  const NightscoutDeviceStatusPanel({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(signal.level);
    if (!signal.available) {
      return NightscoutSignalPanel(
        signal: signal,
        icon: _icon,
        visual: const NightscoutUnavailableVisual(icon: _icon),
      );
    }
    final count = int.tryParse(
          RegExp(r'\d+').firstMatch(signal.valueLabel)?.group(0) ?? '',
        ) ??
        0;
    final lit = count > _cap ? _cap : count;
    final overflow = count > _cap;
    return NightscoutSignalPanel(
      signal: signal,
      icon: _icon,
      visual: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'rows uploaded',
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: NightscoutAnimatedValue(
              value: 1,
              builder: (context, reveal) => CustomPaint(
                painter: _RecordStackPainter(
                  lit: lit,
                  cap: _cap,
                  reveal: reveal,
                  overflow: overflow,
                  color: color,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordStackPainter extends CustomPainter {
  final int lit;
  final int cap;
  final double reveal;
  final bool overflow;
  final Color color;

  const _RecordStackPainter({
    required this.lit,
    required this.cap,
    required this.reveal,
    required this.overflow,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 3.0;
    final barH = (size.height - gap * (cap - 1)) / cap;
    final radius = Radius.circular(barH.clamp(1.5, 3));
    final litProgress = reveal * (lit == 0 ? 1 : lit);

    for (var i = 0; i < cap; i++) {
      final top = size.height - (i + 1) * barH - i * gap;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, top, size.width, barH),
          radius,
        ),
        Paint()..color = StatusMonitorTheme.dim.withOpacity(.12),
      );
      if (i >= lit) continue;
      final local = (litProgress - i).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final isOverflowCap = overflow && i == cap - 1;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, top, size.width * local, barH),
          radius,
        ),
        Paint()
          ..color = color.withOpacity(isOverflowCap ? 1 : .82 * local + .18),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RecordStackPainter oldDelegate) {
    return oldDelegate.lit != lit ||
        oldDelegate.reveal != reveal ||
        oldDelegate.overflow != overflow ||
        oldDelegate.color != color;
  }
}
