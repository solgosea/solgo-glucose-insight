import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';

class CgmSensorDetailSectionFrame extends StatelessWidget {
  final String title;
  final String trailing;
  final Widget child;

  const CgmSensorDetailSectionFrame({
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

class CgmSensorGlassPanel extends StatelessWidget {
  final Widget child;
  final StatusLevel? level;
  final double? minHeight;

  const CgmSensorGlassPanel({
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

class CgmSensorAxis extends StatelessWidget {
  final List<String> labels;

  const CgmSensorAxis({super.key, required this.labels});

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
