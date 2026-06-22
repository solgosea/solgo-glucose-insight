import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/xdrip_signal_view_model.dart';
import 'xdrip_signal_panel.dart';
import 'xdrip_signal_shared.dart';

class XdripFreshnessGauge extends StatefulWidget {
  static const _icon = Icons.sensors_rounded;

  final XdripSignalViewModel signal;

  const XdripFreshnessGauge({super.key, required this.signal});

  @override
  State<XdripFreshnessGauge> createState() => _XdripFreshnessGaugeState();
}

class _XdripFreshnessGaugeState extends State<XdripFreshnessGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  bool get _live =>
      widget.signal.available && widget.signal.level == StatusLevel.healthy;

  @override
  void initState() {
    super.initState();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant XdripFreshnessGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    if (_live) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signal = widget.signal;
    final color = StatusMonitorTheme.colorFor(signal.level);
    return XdripSignalPanel(
      signal: signal,
      icon: XdripFreshnessGauge._icon,
      visual: signal.available
          ? Center(
              child: AspectRatio(
                aspectRatio: 1.62,
                child: XdripAnimatedValue(
                  value: signal.progress,
                  builder: (context, animated) => AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, child) => CustomPaint(
                      painter: _FreshnessPulsePainter(
                        progress: animated,
                        pulse: _live ? _pulse.value : 0,
                        color: color,
                      ),
                      child: child,
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
                            'ago',
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
          : const XdripUnavailableVisual(icon: XdripFreshnessGauge._icon),
    );
  }
}

class _FreshnessPulsePainter extends CustomPainter {
  final double progress;
  final double pulse;
  final Color color;

  const _FreshnessPulsePainter({
    required this.progress,
    required this.pulse,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .34;

    if (pulse > 0) {
      for (var i = 0; i < 3; i++) {
        final local = (pulse + i / 3) % 1;
        canvas.drawCircle(
          center,
          radius * (1 + local * .85),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6
            ..color = color.withOpacity((1 - local) * .22),
        );
      }
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = StatusMonitorTheme.dim.withOpacity(.18),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
    canvas.drawCircle(center, 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _FreshnessPulsePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulse != pulse ||
        oldDelegate.color != color;
  }
}
