import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_aaps_detail_localizer.dart';
import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/aaps/aaps_detail_data.dart';
import '../../../../domain/aaps/aaps_loop_timeline_bucket.dart';
import '../../../../domain/status_level.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../aaps_detail_section_frame.dart';

class AapsLoopEvidenceTimelineCard extends StatelessWidget {
  final AapsDetailData data;

  const AapsLoopEvidenceTimelineCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return AapsDetailSectionFrame(
      title: l10n.pageLoopEvidenceTimeline,
      trailing: l10n.pageLast3h,
      child: AapsGlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.pageLatestContext(
                          statusMonitorAapsValue(data.latestContextLabel, l10n),
                        ),
                        style: StatusMonitorTheme.mono.copyWith(
                          color: StatusMonitorTheme.amber,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.pageNightscoutDeviceStatus,
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
                  l10n.pageOpenapsContext,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _LoopBars(buckets: data.timeline, missingLabel: l10n.pageMissing),
            const SizedBox(height: 8),
            AapsAxis(labels: [l10n.pageThreeHoursAgo, l10n.pageNow]),
            const SizedBox(height: 12),
            StatusLegend(
              items: [
                StatusLegendItem(StatusMonitorTheme.green, l10n.pageFresh),
                StatusLegendItem(
                    StatusMonitorTheme.amber, l10n.pageStalePartial),
                StatusLegendItem(StatusMonitorTheme.rose, l10n.pageStatusIssue),
                StatusLegendItem(StatusMonitorTheme.muted, l10n.pageMissing),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoopBars extends StatelessWidget {
  final List<AapsLoopTimelineBucket> buckets;
  final String missingLabel;

  const _LoopBars({required this.buckets, required this.missingLabel});

  @override
  Widget build(BuildContext context) {
    final visible = buckets.isEmpty
        ? List.generate(
            36,
            (index) => AapsLoopTimelineBucket(
              at: DateTime.fromMillisecondsSinceEpoch(0),
              level: StatusLevel.unknown,
              label: missingLabel,
            ),
          )
        : buckets;
    return SizedBox(
      height: 76,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final bucket in visible.take(36)) ...[
            Expanded(child: _LoopBar(bucket: bucket)),
            const SizedBox(width: 3),
          ],
        ],
      ),
    );
  }
}

class _LoopBar extends StatelessWidget {
  final AapsLoopTimelineBucket bucket;

  const _LoopBar({required this.bucket});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(bucket.level);
    final height = switch (bucket.level) {
      StatusLevel.healthy => .29,
      StatusLevel.watch => .55,
      StatusLevel.issue => .82,
      StatusLevel.unknown => .17,
    };
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(.78),
                color.withOpacity(.28),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
