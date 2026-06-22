import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_age_label_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/detail/status_signal_summary.dart';
import '../../../../domain/nightscout/nightscout_detail_data.dart';
import '../../../../domain/status_level.dart';
import '../../../../l10n/generated/status_monitor_localizations.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../nightscout_detail_section_frame.dart';

class NightscoutServerFreshnessCard extends StatelessWidget {
  final NightscoutDetailData data;

  const NightscoutServerFreshnessCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final endpointCount = data.endpointMatrix.endpoints.length;
    final freshness = _signal(data, 'server_data_freshness');
    final l10n = context.statusMonitorL10n;
    final metricLabel = freshness?.valueLabel.trim();
    final rawFreshnessLabel = metricLabel == null || metricLabel.isEmpty
        ? data.latestServerReadingLabel
        : metricLabel;
    final freshnessLabel = _freshnessDisplay(rawFreshnessLabel, l10n);
    final availableEndpoints = data.endpointMatrix.endpoints
        .where((endpoint) => endpoint.reachable)
        .length;
    return NightscoutDetailSectionFrame(
      title: l10n.pageServerDataFreshness,
      trailing: l10n.pageFromEntriesEndpoint,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final two = constraints.maxWidth >= 320;
          final cards = [
            _MetricCard(
              label: l10n.pageLatestServerReading,
              value: freshnessLabel,
              body: freshness?.note ?? l10n.pageMeasuredLatestEntry,
              level: freshness?.level ?? _freshnessLevel(rawFreshnessLabel),
              fraction: _freshnessFraction(rawFreshnessLabel),
              accent: StatusMonitorTheme.green,
            ),
            _MetricCard(
              label: l10n.pageAvailableEndpoints,
              value: '$availableEndpoints/$endpointCount',
              body: l10n.pageRecentNightscoutEndpoints,
              level: endpointCount == 0
                  ? StatusLevel.unknown
                  : availableEndpoints == endpointCount
                      ? StatusLevel.healthy
                      : availableEndpoints == 0
                          ? StatusLevel.issue
                          : StatusLevel.watch,
              fraction: endpointCount == 0
                  ? .10
                  : (availableEndpoints / endpointCount).clamp(.08, .95),
              accent: StatusMonitorTheme.blue,
            ),
          ];
          if (!two) {
            return Column(
              children: [
                cards[0],
                const SizedBox(height: 10),
                cards[1],
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 10),
              Expanded(child: cards[1]),
            ],
          );
        },
      ),
    );
  }

  StatusSignalSummary? _signal(NightscoutDetailData data, String id) {
    for (final signal in data.signals) {
      if (signal.id == id) return signal;
    }
    return null;
  }

  String _freshnessDisplay(
      String metricValue, StatusMonitorLocalizations l10n) {
    final value = metricValue.trim();
    if (value.isEmpty) return value;
    final ageLocalizer = const StatusMonitorAgeLabelLocalizer();
    if (ageLocalizer.parse(value) != null) {
      return ageLocalizer.localize(value, l10n);
    }
    if (value.contains('ahead')) return value;
    return value;
  }

  StatusLevel _freshnessLevel(String label) {
    if (label == 'No server reading' || label.isEmpty) {
      return StatusLevel.unknown;
    }
    final minutes =
        const StatusMonitorAgeLabelLocalizer().minutes(label) ?? 999;
    if (minutes < 7) return StatusLevel.healthy;
    if (minutes <= 15) return StatusLevel.watch;
    return StatusLevel.issue;
  }

  double _freshnessFraction(String label) {
    final minutes =
        const StatusMonitorAgeLabelLocalizer().minutes(label) ?? 999;
    if (minutes == 999) return .12;
    return (1 - (minutes / 30)).clamp(.08, .95);
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String body;
  final StatusLevel level;
  final double fraction;
  final Color accent;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.body,
    required this.level,
    required this.fraction,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return NightscoutGlassPanel(
      minHeight: 148,
      level: level,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: accent,
              fontSize: 28,
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          StatusGaugeBar(value: fraction, level: level),
        ],
      ),
    );
  }
}
