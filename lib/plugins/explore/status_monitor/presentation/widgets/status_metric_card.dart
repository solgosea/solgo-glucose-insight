import 'package:flutter/material.dart';

import '../../application/i18n/status_monitor_l10n.dart';
import '../../application/i18n/status_monitor_metric_label_localizer.dart';
import '../../domain/status_metric.dart';
import '../styles/status_monitor_theme.dart';

class StatusMetricCard extends StatelessWidget {
  final StatusMetric metric;

  const StatusMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final color = StatusMonitorTheme.colorFor(metric.level);
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: StatusMonitorTheme.cardDecoration(level: metric.level),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statusMonitorMetricLabel(metric.label, l10n).toUpperCase(),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            metric.valueLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.available
                ? metric.threshold?.compact ?? metric.note ?? ''
                : metric.unavailableReason ?? l10n.metricNotAvailable,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
