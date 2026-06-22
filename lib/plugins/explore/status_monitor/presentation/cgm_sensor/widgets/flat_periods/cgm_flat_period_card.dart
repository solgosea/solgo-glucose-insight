import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/cgm_sensor/cgm_flat_period.dart';
import '../../../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../../../domain/status_level.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../cgm_sensor_detail_section_frame.dart';

class CgmFlatPeriodCard extends StatelessWidget {
  final CgmSensorDetailData data;

  const CgmFlatPeriodCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final periods = data.flatTimeline.periods;
    final longest = periods.isEmpty
        ? Duration.zero
        : periods
            .map((period) => period.duration)
            .reduce((a, b) => a >= b ? a : b);
    final level = periods.isEmpty
        ? StatusLevel.healthy
        : periods
            .map((period) => period.level)
            .reduce((a, b) => a.severity >= b.severity ? a : b);
    final l10n = context.statusMonitorL10n;
    return CgmSensorDetailSectionFrame(
      title: l10n.pageFlatPeriods,
      trailing:
          l10n.pageLongestMinutes(periods.isEmpty ? 0 : longest.inMinutes),
      child: CgmSensorGlassPanel(
        level: level,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FlatHeader(periods: periods, level: level),
            const SizedBox(height: 12),
            CgmFlatPeriodTimeline(data: data),
            const SizedBox(height: 8),
            CgmSensorAxis(
              labels: ['24h', '18h', '12h', '6h', l10n.pageNow],
            ),
            const SizedBox(height: 12),
            StatusLegend(
              items: [
                StatusLegendItem(
                    StatusMonitorTheme.green, l10n.pageQuietBaseline),
                StatusLegendItem(StatusMonitorTheme.amber, l10n.pageWatch30m),
                StatusLegendItem(StatusMonitorTheme.rose, l10n.pageIssue60m),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FlatHeader extends StatelessWidget {
  final List<CgmFlatPeriod> periods;
  final StatusLevel level;

  const _FlatHeader({
    required this.periods,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          periods.any((period) => period.duration.inMinutes >= 30)
              ? context.statusMonitorL10n.pageFlatThresholdReached
              : context.statusMonitorL10n.pageNo30mFlatPeriod,
          style: StatusMonitorTheme.mono.copyWith(
            color: StatusMonitorTheme.colorFor(level),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          context.statusMonitorL10n.pageFlatContextNote,
          style: StatusMonitorTheme.inter.copyWith(
            color: StatusMonitorTheme.soft,
            fontSize: 11,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class CgmFlatPeriodTimeline extends StatelessWidget {
  final CgmSensorDetailData data;

  const CgmFlatPeriodTimeline({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dataset = data.flatTimeline;
    return SizedBox(
      height: 58,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const Positioned.fill(child: _QuietBaseline()),
              for (final period in dataset.periods)
                CgmFlatPeriodSegment(
                  period: period,
                  left: _leftFor(
                    period.start,
                    dataset.windowStart,
                    dataset.windowEnd,
                    constraints.maxWidth,
                  ),
                  width: _widthFor(
                    period.start,
                    period.end,
                    dataset.windowStart,
                    dataset.windowEnd,
                    constraints.maxWidth,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  double _leftFor(
    DateTime at,
    DateTime start,
    DateTime end,
    double width,
  ) {
    final total = end.difference(start).inMilliseconds;
    if (total <= 0 || width <= 0) return 0;
    final elapsed = at.difference(start).inMilliseconds;
    return (elapsed / total * width).clamp(0, width);
  }

  double _widthFor(
    DateTime periodStart,
    DateTime periodEnd,
    DateTime windowStart,
    DateTime windowEnd,
    double width,
  ) {
    final total = windowEnd.difference(windowStart).inMilliseconds;
    if (total <= 0 || width <= 0) return 0;
    final start = periodStart.isBefore(windowStart) ? windowStart : periodStart;
    final end = periodEnd.isAfter(windowEnd) ? windowEnd : periodEnd;
    final raw = end.difference(start).inMilliseconds / total * width;
    return raw.clamp(8, width);
  }
}

class CgmFlatPeriodSegment extends StatelessWidget {
  final CgmFlatPeriod period;
  final double left;
  final double width;

  const CgmFlatPeriodSegment({
    super.key,
    required this.period,
    required this.left,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(period.level);
    return Positioned(
      left: left,
      bottom: 13,
      child: Container(
        width: width,
        height: 28,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(.50),
              color.withOpacity(.24),
            ],
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(.38)),
        ),
      ),
    );
  }
}

class _QuietBaseline extends StatelessWidget {
  const _QuietBaseline();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: StatusMonitorTheme.green.withOpacity(.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: StatusMonitorTheme.green.withOpacity(.14)),
        ),
      ),
    );
  }
}
