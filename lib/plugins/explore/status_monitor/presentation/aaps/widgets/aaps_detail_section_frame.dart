import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';

class AapsDetailSectionFrame extends StatelessWidget {
  final String title;
  final String trailing;
  final Widget child;

  const AapsDetailSectionFrame({
    super.key,
    required this.title,
    required this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                trailing,
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.dim,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          child,
        ],
      ),
    );
  }
}

class AapsGlassPanel extends StatelessWidget {
  final Widget child;
  final StatusLevel? level;
  final double? minHeight;

  const AapsGlassPanel({
    super.key,
    required this.child,
    this.level,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          minHeight == null ? null : BoxConstraints(minHeight: minHeight!),
      padding: const EdgeInsets.all(14),
      decoration: StatusMonitorTheme.glassCardDecoration(level: level),
      child: child,
    );
  }
}

class AapsBadge extends StatelessWidget {
  final String label;
  final StatusLevel level;

  const AapsBadge({
    super.key,
    required this.label,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.28)),
      ),
      child: Text(
        label,
        style: StatusMonitorTheme.mono.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class AapsAxis extends StatelessWidget {
  final List<String> labels;

  const AapsAxis({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map(
            (label) => Text(
              label,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.dim,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
