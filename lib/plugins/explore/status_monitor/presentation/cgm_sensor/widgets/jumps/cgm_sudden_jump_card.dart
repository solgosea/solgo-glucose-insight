import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../../../domain/cgm_sensor/cgm_sudden_jump_event.dart';
import '../../../../domain/status_level.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../cgm_sensor_detail_section_frame.dart';

class CgmSuddenJumpCard extends StatelessWidget {
  final CgmSensorDetailData data;

  const CgmSuddenJumpCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final events = data.jumpTimeline.events;
    final level = events.isEmpty
        ? StatusLevel.healthy
        : events.length < 3
            ? StatusLevel.watch
            : StatusLevel.issue;
    final l10n = context.statusMonitorL10n;
    return CgmSensorDetailSectionFrame(
      title: l10n.pageSuddenJumps,
      trailing: l10n.pageMajorJumps(events.length),
      child: CgmSensorGlassPanel(
        level: level,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _JumpHeader(events: events, level: level),
            const SizedBox(height: 12),
            CgmSuddenJumpTimeline(data: data),
            const SizedBox(height: 8),
            CgmSensorAxis(
              labels: ['24h', '18h', '12h', '6h', l10n.pageNow],
            ),
            const SizedBox(height: 12),
            StatusLegend(
              items: [
                StatusLegendItem(
                    StatusMonitorTheme.green, l10n.pageQuietBaseline),
                StatusLegendItem(StatusMonitorTheme.amber, l10n.pageWatchJump),
                StatusLegendItem(StatusMonitorTheme.rose, l10n.pageIssueJump),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JumpHeader extends StatelessWidget {
  final List<CgmSuddenJumpEvent> events;
  final StatusLevel level;

  const _JumpHeader({
    required this.events,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final strongest = events.isEmpty
        ? null
        : events
            .map((event) => event.deltaMmol.abs())
            .reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          events.isEmpty
              ? context.statusMonitorL10n.pageNoAbruptSensorJumps
              : context.statusMonitorL10n
                  .pageLargestJump(strongest!.toStringAsFixed(1)),
          style: StatusMonitorTheme.mono.copyWith(
            color: StatusMonitorTheme.colorFor(level),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          context.statusMonitorL10n.pageAdjacentReadingsOnly,
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

class CgmSuddenJumpTimeline extends StatelessWidget {
  final CgmSensorDetailData data;

  const CgmSuddenJumpTimeline({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dataset = data.jumpTimeline;
    return SizedBox(
      height: 76,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned.fill(child: _QuietBaseline()),
              for (final event in dataset.events)
                CgmSuddenJumpMarker(
                  event: event,
                  left: _leftFor(
                    event.at,
                    dataset.windowStart,
                    dataset.windowEnd,
                    constraints.maxWidth,
                  ),
                  maxHeight: constraints.maxHeight,
                  issueThresholdMmol: dataset.issueThresholdMmol,
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
}

class CgmSuddenJumpMarker extends StatelessWidget {
  final CgmSuddenJumpEvent event;
  final double left;
  final double maxHeight;
  final double issueThresholdMmol;

  const CgmSuddenJumpMarker({
    super.key,
    required this.event,
    required this.left,
    required this.maxHeight,
    required this.issueThresholdMmol,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(event.level);
    final height =
        (18 + event.deltaMmol.abs() / issueThresholdMmol * 42).clamp(22, 68);
    return Positioned(
      left: left.clamp(0, double.infinity),
      bottom: 8,
      child: Transform.translate(
        offset: const Offset(-3, 0),
        child: Container(
          width: 6,
          height: height.toDouble().clamp(18, maxHeight - 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(.95),
                color.withOpacity(.34),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.22),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
      alignment: Alignment.bottomCenter,
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
