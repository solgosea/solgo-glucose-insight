import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_age_label_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../../../domain/detail/status_signal_summary.dart';
import '../../../../domain/status_level.dart';
import '../../../../l10n/generated/status_monitor_localizations.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../cgm_sensor_detail_section_frame.dart';

class CgmVariabilityNoiseCard extends StatelessWidget {
  final CgmSensorDetailData data;

  const CgmVariabilityNoiseCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cv = _signal('cgm_cv_24h');
    final continuity = _signal('signal_continuity');
    final freshness = _signal('sensor_freshness');
    final l10n = context.statusMonitorL10n;
    return CgmSensorDetailSectionFrame(
      title: l10n.pageVariabilityNoise,
      trailing: l10n.pageReadings24h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final two = constraints.maxWidth >= 320;
          final cards = [
            CgmMetricGaugeCard(
              label: l10n.pageCvNoise,
              value: cv?.valueLabel ?? l10n.pageStatusUnknown,
              body: l10n.pageCvWatchBody,
              level: cv?.level ?? StatusLevel.unknown,
              fraction: _cvFraction(cv?.valueLabel),
            ),
            CgmMetricGaugeCard(
              label: l10n.pageContinuity,
              value: continuity?.valueLabel ?? l10n.pageStatusUnknown,
              body: _continuityBody(freshness, l10n),
              level: continuity?.level ?? StatusLevel.unknown,
              fraction: _continuityFraction(continuity?.valueLabel),
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

  StatusSignalSummary? _signal(String id) {
    for (final signal in data.signals) {
      if (signal.id == id) return signal;
    }
    return null;
  }

  double _cvFraction(String? label) {
    if (label == null) return 0;
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(label);
    final value = double.tryParse(match?.group(1) ?? '');
    if (value == null) return 0;
    return (value / 50).clamp(0, 1);
  }

  double _continuityFraction(String? label) {
    if (label == null) return 0;
    if (label.toLowerCase().contains('continuous')) return .96;
    final match = RegExp(r'(\d+)m').firstMatch(label);
    final minutes = double.tryParse(match?.group(1) ?? '');
    if (minutes != null) return (1 - minutes / 30).clamp(.08, .96);
    final healthyBuckets = data.qualityTimeline
        .where((bucket) => bucket.level == StatusLevel.healthy)
        .length;
    if (data.qualityTimeline.isEmpty) return 0;
    return (healthyBuckets / data.qualityTimeline.length).clamp(.08, .96);
  }

  String _continuityBody(
    StatusSignalSummary? freshness,
    StatusMonitorLocalizations l10n,
  ) {
    final latest = freshness?.valueLabel;
    if (latest == null || latest.isEmpty) {
      return l10n.pageObservedCadenceBody;
    }
    return l10n.pageCadenceFreshnessBody(_ageLabel(latest, l10n));
  }

  String _ageLabel(String value, StatusMonitorLocalizations l10n) {
    return const StatusMonitorAgeLabelLocalizer()
        .localize(value, l10n, fallback: value);
  }
}

class CgmMetricGaugeCard extends StatelessWidget {
  final String label;
  final String value;
  final String body;
  final StatusLevel level;
  final double fraction;

  const CgmMetricGaugeCard({
    super.key,
    required this.label,
    required this.value,
    required this.body,
    required this.level,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return CgmSensorGlassPanel(
      minHeight: 154,
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
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 30,
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
