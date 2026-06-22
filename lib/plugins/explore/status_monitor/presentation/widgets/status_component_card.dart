import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../application/i18n/status_monitor_l10n.dart';
import '../../application/i18n/status_monitor_metric_label_localizer.dart';
import '../../domain/scoring/status_component_score.dart';
import '../../domain/status_component_kind.dart';
import '../models/status_view_models.dart';
import '../styles/status_monitor_theme.dart';
import 'status_level_pill.dart';

class StatusComponentCard extends StatelessWidget {
  final StatusDashboardComponentViewModel viewModel;

  const StatusComponentCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final component = viewModel.component;
    final color = StatusMonitorTheme.colorFor(component.level);
    final score = component.score;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 340;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push(
            '/explore/status/component?kind=${component.kind.queryValue}',
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            padding: EdgeInsets.all(compact ? 13 : 15),
            decoration:
                StatusMonitorTheme.cardDecoration(level: component.level),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: compact ? 38 : 44,
                  height: compact ? 38 : 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.13),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    _icon(component.kind),
                    color: color,
                    size: compact ? 20 : 23,
                  ),
                ),
                SizedBox(width: compact ? 10 : 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        component.role,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StatusMonitorTheme.mono.copyWith(
                          color: StatusMonitorTheme.dim,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .8,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              component.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: StatusMonitorTheme.inter.copyWith(
                                color: StatusMonitorTheme.text,
                                fontSize: compact ? 15.5 : 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusLevelPill(
                            level: component.level,
                            compact: compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      if (score == null) ...[
                        Text(
                          component.takeaway,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StatusMonitorTheme.inter.copyWith(
                            color: StatusMonitorTheme.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        component.summary,
                        maxLines: compact ? 2 : null,
                        overflow: compact ? TextOverflow.ellipsis : null,
                        style: StatusMonitorTheme.inter.copyWith(
                          color: StatusMonitorTheme.soft,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.sync_rounded,
                            size: 11,
                            color: color.withOpacity(.78),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              viewModel.freshnessText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: StatusMonitorTheme.mono.copyWith(
                                color: color.withOpacity(.78),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: compact ? 7 : 10),
                if (score != null)
                  _HealthDial(score: score, color: color, compact: compact)
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: StatusMonitorTheme.dim,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _icon(StatusComponentKind kind) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => Icons.sensors_rounded,
      StatusComponentKind.xdrip => Icons.phone_android_rounded,
      StatusComponentKind.nightscout => Icons.cloud_rounded,
      StatusComponentKind.aapsLoop => Icons.loop_rounded,
    };
  }
}

class _HealthDial extends StatelessWidget {
  static const _lowConfidence = .6;

  final StatusComponentScore score;
  final Color color;
  final bool compact;

  const _HealthDial({
    required this.score,
    required this.color,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final lowConfidence = score.confidence < _lowConfidence;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: compact ? 46 : 52,
          height: compact ? 46 : 52,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: (score.value / 100).clamp(0, 1)),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, animated, _) => CustomPaint(
              painter: _ScoreRingPainter(
                progress: animated,
                color: color,
                dashed: lowConfidence,
              ),
              child: Center(
                child: Text(
                  '${score.value}',
                  style: StatusMonitorTheme.mono.copyWith(
                    color: color,
                    fontSize: compact ? 15 : 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: compact ? 52 : 64,
          child: Text(
            statusMonitorMetricLabel(score.label, l10n),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: compact ? 9.5 : 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (score.totalSignals > 0) ...[
          const SizedBox(height: 5),
          _SignalDots(
            available: score.availableSignals,
            total: score.totalSignals,
            color: color,
          ),
        ],
      ],
    );
  }
}

class _SignalDots extends StatelessWidget {
  final int available;
  final int total;
  final Color color;

  const _SignalDots({
    required this.available,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < total; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < available
                    ? color
                    : StatusMonitorTheme.dim.withOpacity(.30),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool dashed;

  const _ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.dashed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 5.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - stroke / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = StatusMonitorTheme.dim.withOpacity(.18),
    );

    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(dashed ? .85 : 1);
    const start = -math.pi / 2;
    final sweep = math.pi * 2 * progress.clamp(0, 1);

    if (!dashed) {
      canvas.drawArc(rect, start, sweep, false, active);
      return;
    }
    const dash = 0.32;
    const gap = 0.20;
    final end = start + sweep;
    var a = start;
    while (a < end) {
      final seg = math.min(dash, end - a);
      canvas.drawArc(rect, a, seg, false, active);
      a += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.dashed != dashed;
  }
}
