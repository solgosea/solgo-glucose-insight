import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/detail/status_response_time_point.dart';
import '../../../../domain/nightscout/nightscout_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../nightscout_detail_section_frame.dart';

class NightscoutResponseTimelineCard extends StatelessWidget {
  final NightscoutDetailData data;

  const NightscoutResponseTimelineCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return NightscoutDetailSectionFrame(
      title: l10n.pageResponseTimeline,
      trailing: l10n.pageLast30m,
      child: _ResponseTimeline(data: data),
    );
  }
}

class _ResponseTimeline extends StatelessWidget {
  final NightscoutDetailData data;

  const _ResponseTimeline({required this.data});

  @override
  Widget build(BuildContext context) {
    final points = data.responseTimeline.points;
    final l10n = context.statusMonitorL10n;
    if (points.isEmpty) {
      return NightscoutGlassPanel(
        child: Text(
          l10n.pageNoResponseSamples,
          style: StatusMonitorTheme.inter.copyWith(
            color: StatusMonitorTheme.soft,
            fontSize: 11.5,
            height: 1.45,
          ),
        ),
      );
    }
    return NightscoutGlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.pageMedianMs(
                    data.responseTimeline.median?.inMilliseconds ?? 0,
                  ),
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.amber,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                l10n.pageTimeouts(data.responseTimeline.timeoutCount),
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            data.responseTimeline.timeoutCount == 0
                ? l10n.pageNoRecentTimeouts
                : l10n.pageRecentTimeoutsVisible,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 74,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 340 ? 20 : 30;
                final visible = points.take(columns).toList(growable: false);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final point in visible) ...[
                      Expanded(child: _ResponseBar(point: point)),
                      const SizedBox(width: 3),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const NightscoutAxis(labels: ['-30m', '-20m', '-10m', 'Now']),
          const SizedBox(height: 12),
          const StatusLegend(
            items: [
              StatusLegendItem(StatusMonitorTheme.green, '<500ms'),
              StatusLegendItem(StatusMonitorTheme.amber, '500ms-3s'),
              StatusLegendItem(StatusMonitorTheme.rose, 'timeout / >3s'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResponseBar extends StatelessWidget {
  final StatusResponseTimePoint point;

  const _ResponseBar({required this.point});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(point.level);
    final elapsed = point.elapsed;
    final timeout = point.timeout;
    final height = timeout
        ? .92
        : (elapsed.inMilliseconds / 3000).clamp(.18, .82).toDouble();
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
                color.withOpacity(.82),
                color.withOpacity(.28),
              ],
            ),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: color.withOpacity(.22)),
          ),
        ),
      ),
    );
  }
}
