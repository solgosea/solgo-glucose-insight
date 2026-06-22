import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/nightscout_signal_view_model.dart';
import 'nightscout_signal_panel.dart';
import 'nightscout_signal_shared.dart';

class NightscoutReachabilityPanel extends StatefulWidget {
  static const _icon = Icons.cloud_done_rounded;

  final NightscoutSignalViewModel signal;

  const NightscoutReachabilityPanel({super.key, required this.signal});

  @override
  State<NightscoutReachabilityPanel> createState() =>
      _NightscoutReachabilityPanelState();
}

class _NightscoutReachabilityPanelState
    extends State<NightscoutReachabilityPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waves = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  double get _strength {
    return switch (widget.signal.level) {
      StatusLevel.healthy => 1,
      StatusLevel.watch => .55,
      _ => 0,
    };
  }

  bool get _down =>
      widget.signal.level == StatusLevel.issue ||
      widget.signal.level == StatusLevel.unknown;

  @override
  void initState() {
    super.initState();
    _syncWaves();
  }

  @override
  void didUpdateWidget(covariant NightscoutReachabilityPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncWaves();
  }

  void _syncWaves() {
    if (_strength > 0) {
      if (!_waves.isAnimating) _waves.repeat();
    } else {
      _waves
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _waves.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signal = widget.signal;
    final color = StatusMonitorTheme.colorFor(signal.level);
    return NightscoutSignalPanel(
      signal: signal,
      icon: NightscoutReachabilityPanel._icon,
      visual: signal.available
          ? AnimatedBuilder(
              animation: _waves,
              builder: (context, child) => CustomPaint(
                painter: _ReachabilityWavePainter(
                  pulse: _waves.value,
                  strength: _strength,
                  down: _down,
                  color: color,
                ),
                child: child,
              ),
              child: Center(
                child: Text(
                  signal.valueLabel,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              ),
            )
          : const NightscoutUnavailableVisual(
              icon: NightscoutReachabilityPanel._icon,
            ),
    );
  }
}

class _ReachabilityWavePainter extends CustomPainter {
  final double pulse;
  final double strength;
  final bool down;
  final Color color;

  const _ReachabilityWavePainter({
    required this.pulse,
    required this.strength,
    required this.down,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * .46;

    if (strength > 0) {
      for (var i = 0; i < 3; i++) {
        final local = (pulse + i / 3) % 1;
        canvas.drawCircle(
          center,
          maxRadius * (.34 + local * .66),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6
            ..color = color.withOpacity((1 - local) * .32 * strength),
        );
      }
    } else {
      canvas.drawCircle(
        center,
        maxRadius * .8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = StatusMonitorTheme.dim.withOpacity(.25),
      );
    }

    canvas.drawCircle(
      center,
      maxRadius * .30,
      Paint()..color = color.withOpacity(.12),
    );
    canvas.drawCircle(center, 4, Paint()..color = color);

    if (down) {
      final d = maxRadius * .26;
      canvas.drawLine(
        center + Offset(-d, -d),
        center + Offset(d, d),
        Paint()
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ReachabilityWavePainter oldDelegate) {
    return oldDelegate.pulse != pulse ||
        oldDelegate.strength != strength ||
        oldDelegate.down != down ||
        oldDelegate.color != color;
  }
}
