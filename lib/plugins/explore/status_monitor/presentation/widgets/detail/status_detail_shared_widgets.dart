import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../../application/i18n/status_monitor_metric_label_localizer.dart';
import '../../../domain/detail/status_signal_summary.dart';
import '../../../domain/detail/status_timeline_bucket.dart';
import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';

class StatusSignalStrip extends StatelessWidget {
  final List<StatusSignalSummary> signals;

  const StatusSignalStrip({super.key, required this.signals});

  @override
  Widget build(BuildContext context) {
    if (signals.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 11, 20, 0),
      child: StatusSignalStripContent(signals: signals),
    );
  }

  static String glyphFor(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => '●',
      StatusLevel.watch => '▲',
      StatusLevel.issue => '■',
      StatusLevel.unknown => '○',
    };
  }
}

class StatusSignalStripContent extends StatelessWidget {
  final List<StatusSignalSummary> signals;

  const StatusSignalStripContent({super.key, required this.signals});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x5708110D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StatusMonitorTheme.line),
      ),
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: signals
            .map(
              (signal) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StatusSignalStrip.glyphFor(signal.level),
                    style: StatusMonitorTheme.mono.copyWith(
                      color: StatusMonitorTheme.colorFor(signal.level),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    statusMonitorMetricLabel(signal.label, l10n),
                    style: StatusMonitorTheme.mono.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class StatusDetailSectionLabel extends StatelessWidget {
  final String text;
  final String? trailing;

  const StatusDetailSectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.text,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.dim,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}

class StatusTimelineStrip extends StatelessWidget {
  final List<StatusTimelineBucket> buckets;

  const StatusTimelineStrip({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    if (buckets.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: StatusMonitorTheme.glassCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineReadout(buckets: buckets),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 340 ? 32 : 48;
                final visible = buckets.take(columns).toList(growable: false);
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final bucket = visible[index];
                    final color = StatusMonitorTheme.colorFor(bucket.level);
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            color.withOpacity(.74),
                            color.withOpacity(.30),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _TimelineAxis(
            labels: buckets.length >= 32
                ? ['00:00', '06:00', '12:00', '18:00', l10n.pageNow]
                : [l10n.pageOlder, l10n.pageMid, l10n.pageNow],
          ),
          const SizedBox(height: 12),
          StatusLegend(
            items: [
              StatusLegendItem(
                StatusMonitorTheme.green,
                l10n.pageHealthyCadence,
              ),
              StatusLegendItem(StatusMonitorTheme.amber, l10n.pageDelayed),
              StatusLegendItem(StatusMonitorTheme.rose, l10n.pageGap),
              StatusLegendItem(StatusMonitorTheme.muted, l10n.pageUnknownLower),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String body;
  final StatusLevel level;

  const StatusInfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.body,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: StatusMonitorTheme.glassCardDecoration(level: level),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.05,
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
        ],
      ),
    );
  }
}

class StatusTwoColumn extends StatelessWidget {
  final List<Widget> children;

  const StatusTwoColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth > 520 ? 2 : 1;
          final width = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: children
                .map((child) => SizedBox(width: width, child: child))
                .toList(growable: false),
          );
        },
      ),
    );
  }
}

class StatusLegend extends StatelessWidget {
  final List<StatusLegendItem> items;

  const StatusLegend({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  item.label,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 10.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          )
          .toList(growable: false),
    );
  }
}

class StatusLegendItem {
  final Color color;
  final String label;

  const StatusLegendItem(this.color, this.label);
}

class StatusGaugeBar extends StatelessWidget {
  final double value;
  final StatusLevel level;

  const StatusGaugeBar({
    super.key,
    required this.value,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 8,
        color: Colors.white.withOpacity(.06),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0, 1),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(.72), color],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineReadout extends StatelessWidget {
  final List<StatusTimelineBucket> buckets;

  const _TimelineReadout({required this.buckets});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final last = buckets.isEmpty ? null : buckets.last;
    final issueCount =
        buckets.where((bucket) => bucket.level == StatusLevel.issue).length;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                last == null
                    ? l10n.pageNoTimelineData
                    : l10n.pageLatestTimelineLabel(
                        statusMonitorMetricLabel(last.label, l10n),
                      ),
                style: StatusMonitorTheme.mono.copyWith(
                  color: last == null
                      ? StatusMonitorTheme.dim
                      : StatusMonitorTheme.colorFor(last.level),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                issueCount == 0
                    ? l10n.pageNoVisibleIssueCluster
                    : l10n.pageIssueBucketsInView(issueCount),
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
    );
  }
}

class _TimelineAxis extends StatelessWidget {
  final List<String> labels;

  const _TimelineAxis({required this.labels});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map(
            (label) => Text(
              label,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.dim,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
