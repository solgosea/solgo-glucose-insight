import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../application/checking/models/status_check_component_phase.dart';
import '../../styles/status_monitor_theme.dart';

class StatusComponentCheckIndicator extends StatefulWidget {
  final StatusCheckComponentPhase phase;
  final Color color;
  final bool compact;

  const StatusComponentCheckIndicator({
    super.key,
    required this.phase,
    required this.color,
    required this.compact,
  });

  @override
  State<StatusComponentCheckIndicator> createState() =>
      _StatusComponentCheckIndicatorState();
}

class _StatusComponentCheckIndicatorState
    extends State<StatusComponentCheckIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  bool get _animated =>
      widget.phase == StatusCheckComponentPhase.checking ||
      widget.phase == StatusCheckComponentPhase.queued;

  @override
  void initState() {
    super.initState();
    if (_animated) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant StatusComponentCheckIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_animated && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!_animated && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 42.0 : 48.0;
    final icon = switch (widget.phase) {
      StatusCheckComponentPhase.failed => Icons.warning_amber_rounded,
      StatusCheckComponentPhase.skipped => Icons.remove_circle_outline_rounded,
      StatusCheckComponentPhase.cancelled => Icons.pause_circle_outline_rounded,
      _ => Icons.sync_rounded,
    };
    final color = switch (widget.phase) {
      StatusCheckComponentPhase.failed => StatusMonitorTheme.rose,
      StatusCheckComponentPhase.skipped ||
      StatusCheckComponentPhase.cancelled =>
        StatusMonitorTheme.dim,
      _ => widget.color,
    };

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final pulse = widget.phase == StatusCheckComponentPhase.queued
              ? 0.65 + 0.25 * math.sin(_controller.value * math.pi * 2)
              : 1.0;
          return CustomPaint(
            painter: _CheckRingPainter(
              progress: _controller.value,
              color: color,
              animated: widget.phase == StatusCheckComponentPhase.checking,
              pulseOpacity: pulse,
            ),
            child: Center(
              child: Icon(
                icon,
                color: color.withValues(alpha: pulse),
                size: widget.compact ? 17 : 19,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CheckRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool animated;
  final double pulseOpacity;

  const _CheckRingPainter({
    required this.progress,
    required this.color,
    required this.animated,
    required this.pulseOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 3;
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = color.withValues(alpha: .15 * pulseOpacity);
    canvas.drawCircle(center, radius, base);

    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: .90 * pulseOpacity);
    final start =
        animated ? progress * math.pi * 2 - math.pi / 2 : -math.pi / 2;
    final sweep = animated ? math.pi * 1.24 : math.pi * 2 * .68;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.animated != animated ||
        oldDelegate.pulseOpacity != pulseOpacity;
  }
}
