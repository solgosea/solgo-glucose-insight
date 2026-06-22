import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_age_label_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../../../domain/detail/status_timeline_bucket.dart';
import '../../../../domain/status_level.dart';
import '../../../../l10n/generated/status_monitor_localizations.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../cgm_sensor_detail_section_frame.dart';

class CgmSensorQualityTimelineCard extends StatelessWidget {
  final CgmSensorDetailData data;

  const CgmSensorQualityTimelineCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return CgmSensorDetailSectionFrame(
      title: l10n.pageSensorQualityTimeline,
      trailing: l10n.pageLast24h,
      child: CgmSensorGlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _QualityTimelineHeader(data: data),
            const SizedBox(height: 12),
            CgmQualityTimelineBars(buckets: data.qualityTimeline),
            const SizedBox(height: 8),
            CgmSensorAxis(
              labels: ['00:00', '06:00', '12:00', '18:00', l10n.pageNow],
            ),
            const SizedBox(height: 12),
            StatusLegend(
              items: [
                StatusLegendItem(StatusMonitorTheme.green, l10n.pageContinuous),
                StatusLegendItem(StatusMonitorTheme.amber, l10n.pageSparse),
                StatusLegendItem(StatusMonitorTheme.rose, l10n.pageGap),
                StatusLegendItem(
                    StatusMonitorTheme.muted, l10n.pageUnknownLower),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityTimelineHeader extends StatelessWidget {
  final CgmSensorDetailData data;

  const _QualityTimelineHeader({required this.data});

  @override
  Widget build(BuildContext context) {
    final gapCount = data.qualityTimeline
        .where((bucket) => bucket.level == StatusLevel.issue)
        .length;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.statusMonitorL10n.pageLatestAge(
                  _ageLabel(
                    data.latestReadingAgeLabel,
                    context.statusMonitorL10n,
                  ),
                ),
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.colorFor(data.latestReadingLevel),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                gapCount == 0
                    ? '${context.statusMonitorL10n.pageNoVisibleGap} | ${data.qualityTimelineSourceLabel}'
                    : '${context.statusMonitorL10n.pageGapBuckets(gapCount)} | ${data.qualityTimelineSourceLabel}',
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
          context.statusMonitorL10n.pageNow,
          style: StatusMonitorTheme.inter.copyWith(
            color: StatusMonitorTheme.soft,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  String _ageLabel(
    String value,
    StatusMonitorLocalizations l10n,
  ) {
    return const StatusMonitorAgeLabelLocalizer()
        .localize(value, l10n, fallback: value);
  }
}

class CgmQualityTimelineBars extends StatelessWidget {
  final List<StatusTimelineBucket> buckets;

  const CgmQualityTimelineBars({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) return const SizedBox(height: 42);
    return SizedBox(
      height: 42,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 340 ? 32 : 48;
          final visible = buckets.take(columns).toList(growable: false);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: visible
                .map(
                  (bucket) => Expanded(
                    child: _QualityBar(bucket: bucket),
                  ),
                )
                .toList(growable: false),
          );
        },
      ),
    );
  }
}

class _QualityBar extends StatelessWidget {
  final StatusTimelineBucket bucket;

  const _QualityBar({required this.bucket});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(bucket.level);
    return Container(
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
    );
  }
}
