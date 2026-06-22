import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_age_label_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/detail/status_signal_summary.dart';
import '../../../../domain/status_level.dart';
import '../../../../domain/xdrip/xdrip_detail_data.dart';
import '../../../../l10n/generated/status_monitor_localizations.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../xdrip_detail_section_frame.dart';

class XdripFreshnessTimelineCard extends StatelessWidget {
  final XdripDetailData data;

  const XdripFreshnessTimelineCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return XdripDetailSectionFrame(
      title: l10n.pageDataFreshnessTimeline,
      trailing: l10n.pageLast24h,
      child: _FreshnessTimeline(data: data),
    );
  }
}

class _FreshnessTimeline extends StatelessWidget {
  final XdripDetailData data;

  const _FreshnessTimeline({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.freshnessTimeline.isEmpty) return const SizedBox.shrink();
    final latestBucket = data.freshnessTimeline.last;
    final freshness = _signal(data, 'freshness');
    final gapCount = data.freshnessTimeline
        .where((bucket) => bucket.level == StatusLevel.issue)
        .length;
    final l10n = context.statusMonitorL10n;
    return XdripGlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pageLatestAge(
                        _freshnessLabel(
                          freshness?.valueLabel,
                          latestBucket.label,
                          l10n,
                        ),
                      ),
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.colorFor(
                          freshness?.level ?? latestBucket.level,
                        ),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      gapCount == 0
                          ? l10n.pageNoVisibleGap
                          : l10n.pageGapBuckets(gapCount),
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.pageNow,
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 340 ? 32 : 48;
                final visible = data.freshnessTimeline
                    .take(columns)
                    .toList(growable: false);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: visible.map((bucket) {
                    final color = StatusMonitorTheme.colorFor(bucket.level);
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              color.withOpacity(.72),
                              color.withOpacity(.30),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }).toList(growable: false),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          XdripAxis(labels: ['00:00', '06:00', '12:00', '18:00', l10n.pageNow]),
          const SizedBox(height: 12),
          StatusLegend(
            items: [
              StatusLegendItem(
                  StatusMonitorTheme.green, l10n.pageHealthyCadence),
              StatusLegendItem(StatusMonitorTheme.amber, l10n.pageDelayed),
              StatusLegendItem(StatusMonitorTheme.rose, l10n.pageGap),
              StatusLegendItem(StatusMonitorTheme.muted, l10n.pageUnknownLower),
            ],
          ),
        ],
      ),
    );
  }

  StatusSignalSummary? _signal(XdripDetailData data, String id) {
    for (final signal in data.signals) {
      if (signal.id == id) return signal;
    }
    return null;
  }

  String _freshnessLabel(
    String? metricValue,
    String fallback,
    StatusMonitorLocalizations l10n,
  ) {
    final value =
        metricValue == null || metricValue.isEmpty ? fallback : metricValue;
    if (value.contains('reading')) return value;
    if (value == 'Unknown') return value;
    final ageLocalizer = const StatusMonitorAgeLabelLocalizer();
    if (ageLocalizer.parse(value) != null) {
      return ageLocalizer.localize(value, l10n);
    }
    if (value.endsWith('ahead')) return value;
    return value;
  }
}
