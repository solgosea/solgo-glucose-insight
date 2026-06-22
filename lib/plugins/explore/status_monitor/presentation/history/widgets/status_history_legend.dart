import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../../application/i18n/status_monitor_status_level_localizer.dart';
import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHistoryLegend extends StatelessWidget {
  const StatusHistoryLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StatusMonitorTheme.border),
      ),
      child: const Wrap(
        spacing: 14,
        runSpacing: 8,
        children: [
          _LegendItem(level: StatusLevel.healthy),
          _LegendItem(level: StatusLevel.watch),
          _LegendItem(level: StatusLevel.issue),
          _LegendItem(level: StatusLevel.unknown),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final StatusLevel level;

  const _LegendItem({required this.level});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final color = StatusMonitorTheme.colorFor(level);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color.withOpacity(level == StatusLevel.unknown ? .30 : .50),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          statusMonitorLevelLabel(level, l10n),
          style: StatusMonitorTheme.mono.copyWith(
            color: StatusMonitorTheme.soft,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
