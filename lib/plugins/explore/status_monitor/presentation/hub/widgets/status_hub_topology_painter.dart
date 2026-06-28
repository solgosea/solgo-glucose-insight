import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../domain/hub/status_hub_enums.dart';
import '../models/status_hub_view_model.dart';
import 'status_hub_visuals.dart';
import '../../styles/status_monitor_theme.dart';

/// Normalized node centers, derived from the HTML viewBox (340 x 360).
class StatusHubMapGeometry {
  const StatusHubMapGeometry._();

  static const center = Offset(170 / 340, 185 / 360);
  static const cgm = Offset(54 / 340, 150 / 360);
  static const juggluco = Offset(286 / 340, 150 / 360);
  static const nightscout = Offset(170 / 340, 66 / 360);
  static const aaps = Offset(241 / 340, 286 / 360);
  static const watch = Offset(99 / 340, 286 / 360);

  static Offset endpointFor(StatusHubConnectionId id) {
    return switch (id) {
      StatusHubConnectionId.cgmToXdrip => cgm,
      StatusHubConnectionId.jugglucoToXdrip => juggluco,
      StatusHubConnectionId.xdripToNightscout => nightscout,
      StatusHubConnectionId.xdripToAaps => aaps,
      StatusHubConnectionId.xdripToWatch => watch,
    };
  }

  /// Normalized center for a connection's chip, placed along the spoke and
  /// nudged along the line's normal so it sits beside the line without
  /// overlapping the hub or the end node. [t] is the position along the spoke
  /// (0 = hub, 1 = node); [normalShift] pushes the chip perpendicular to the
  /// spoke (in viewBox units, positive = one side, negative = the other).
  static Offset chipCenterFor(StatusHubConnectionId id) {
    final node = endpointFor(id);
    final params = _chipParams(id);
    // Work in viewBox units, then re-normalize.
    final hub = const Offset(170, 185);
    final end = Offset(node.dx * 340, node.dy * 360);
    final point = Offset.lerp(hub, end, params.t)!;
    final dir = end - hub;
    final len = dir.distance;
    if (len == 0) return Offset(point.dx / 340, point.dy / 360);
    // Unit normal (perpendicular to the spoke).
    final nx = -dir.dy / len;
    final ny = dir.dx / len;
    final shifted = Offset(
      point.dx + nx * params.normalShift,
      point.dy + ny * params.normalShift,
    );
    return Offset(shifted.dx / 340, shifted.dy / 360);
  }

  static _ChipPlacement _chipParams(StatusHubConnectionId id) {
    return switch (id) {
      // top spokes: push chips outward/down toward the line midpoint
      StatusHubConnectionId.cgmToXdrip =>
        const _ChipPlacement(t: .52, normalShift: -16),
      StatusHubConnectionId.jugglucoToXdrip =>
        const _ChipPlacement(t: .52, normalShift: 16),
      StatusHubConnectionId.xdripToNightscout =>
        const _ChipPlacement(t: .5, normalShift: 22),
      // bottom spokes
      StatusHubConnectionId.xdripToAaps =>
        const _ChipPlacement(t: .54, normalShift: 18),
      StatusHubConnectionId.xdripToWatch =>
        const _ChipPlacement(t: .54, normalShift: -18),
    };
  }
}

class _ChipPlacement {
  final double t;
  final double normalShift;
  const _ChipPlacement({required this.t, required this.normalShift});
}

class StatusHubTopologyPainter extends CustomPainter {
  final List<StatusHubConnectionViewModel> connections;

  /// Animated dash offset driving the flowing connection lines (0..1 looped).
  final double dashPhase;

  const StatusHubTopologyPainter({
    required this.connections,
    required this.dashPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = _resolve(size, StatusHubMapGeometry.center);
    _drawGuideRings(canvas, size, center);
    for (final connection in connections) {
      _drawConnection(canvas, size, center, connection);
    }
  }

  Offset _resolve(Size size, Offset normalized) {
    return Offset(size.width * normalized.dx, size.height * normalized.dy);
  }

  void _drawGuideRings(Canvas canvas, Size size, Offset center) {
    final ringPaint = Paint()
      ..color = StatusMonitorTheme.green.withOpacity(.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    // HTML radii 62 / 98 / 132 over a 340-wide viewBox.
    for (final radius in [62 / 340, 98 / 340, 132 / 340]) {
      canvas.drawCircle(center, size.width * radius, ringPaint);
    }
    final crossPaint = Paint()
      ..color = StatusMonitorTheme.green.withOpacity(.07)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width * (38 / 340), center.dy),
      Offset(size.width * (302 / 340), center.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx, size.height * (53 / 360)),
      Offset(center.dx, size.height * (317 / 360)),
      crossPaint,
    );
  }

  void _drawConnection(
    Canvas canvas,
    Size size,
    Offset center,
    StatusHubConnectionViewModel connection,
  ) {
    final endpoint =
        _resolve(size, StatusHubMapGeometry.endpointFor(connection.id));
    final color = StatusHubVisuals.colorFor(connection.state);
    final isUnknown = connection.state == StatusHubState.notChecked ||
        connection.state == StatusHubState.unknown;
    final priority = connection.priority;

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(endpoint.dx, endpoint.dy);

    if (isUnknown) {
      // Static muted dashed spoke, no flow animation (HTML dasharray 3 6).
      final dashed = _dashPath(path, dash: 3, gap: 6, phase: 0);
      canvas.drawPath(
        dashed,
        Paint()
          ..color = StatusMonitorTheme.dim.withOpacity(.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );
      return;
    }

    // Base spoke (solid, low opacity).
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = priority ? 3 : 2.4
        ..strokeCap = StrokeCap.round,
    );

    // Flow overlay (animated dashes, HTML dash 5 / gap 11 → period 16).
    const period = 16.0;
    final speed = priority ? 1.0 / 0.95 : 1.0 / 1.15;
    final phase = (dashPhase * speed * period) % period;
    final flow = _dashPath(path, dash: 5, gap: 11, phase: phase);
    canvas.drawPath(
      flow,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = priority ? 3.1 : 2.6
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Returns a dashed copy of [source] with the given dash/gap lengths,
  /// offset by [phase] so the dashes appear to travel along the path.
  Path _dashPath(
    Path source, {
    required double dash,
    required double gap,
    required double phase,
  }) {
    final result = Path();
    final period = dash + gap;
    for (final ui.PathMetric metric in source.computeMetrics()) {
      // Start one period earlier so the leading dash enters smoothly.
      double distance = -((phase % period));
      while (distance < metric.length) {
        final start = distance.clamp(0.0, metric.length);
        final end = (distance + dash).clamp(0.0, metric.length);
        if (end > start) {
          result.addPath(metric.extractPath(start, end), Offset.zero);
        }
        distance += period;
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant StatusHubTopologyPainter oldDelegate) {
    return oldDelegate.dashPhase != dashPhase ||
        oldDelegate.connections != connections;
  }
}
