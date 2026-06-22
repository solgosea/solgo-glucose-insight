import 'package:flutter/material.dart';

import '../../../../application/i18n/status_monitor_l10n.dart';
import '../../../../domain/xdrip/xdrip_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_detail_shared_widgets.dart';
import '../xdrip_detail_section_frame.dart';

class XdripCompletenessHeatCard extends StatelessWidget {
  final XdripDetailData data;

  const XdripCompletenessHeatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final totals = _CompletenessTotals.from(data);
    final l10n = context.statusMonitorL10n;
    return XdripDetailSectionFrame(
      title: l10n.pageCompleteness24h,
      trailing: l10n.pageExpectedReadings(totals.observed, totals.expected),
      child: _CompletenessHeat(data: data, totals: totals),
    );
  }
}

class _CompletenessHeat extends StatelessWidget {
  final XdripDetailData data;
  final _CompletenessTotals totals;

  const _CompletenessHeat({
    required this.data,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    if (data.completenessBuckets.isEmpty) return const SizedBox.shrink();
    final l10n = context.statusMonitorL10n;
    return XdripGlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pageCoveragePercent(totals.percent),
            style: StatusMonitorTheme.mono.copyWith(
              color: totals.percent >= 95
                  ? StatusMonitorTheme.green
                  : totals.percent >= 85
                      ? StatusMonitorTheme.amber
                      : StatusMonitorTheme.rose,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            l10n.pageExpectedFiveMinuteCadence,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 11,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 340 ? 8 : 12;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.45,
                ),
                itemCount: data.completenessBuckets.length,
                itemBuilder: (context, index) {
                  final bucket = data.completenessBuckets[index];
                  final color = StatusMonitorTheme.colorFor(bucket.level);
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color.withOpacity(.48),
                          color.withOpacity(.20),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white.withOpacity(.04)),
                    ),
                    child: Text(
                      '${bucket.observed}',
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.text.withOpacity(.82),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          const StatusLegend(
            items: [
              StatusLegendItem(StatusMonitorTheme.green, '11-12/hour'),
              StatusLegendItem(StatusMonitorTheme.amber, '9-10/hour'),
              StatusLegendItem(StatusMonitorTheme.rose, '0-8/hour'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompletenessTotals {
  final int observed;
  final int expected;
  final int percent;

  const _CompletenessTotals({
    required this.observed,
    required this.expected,
    required this.percent,
  });

  factory _CompletenessTotals.from(XdripDetailData data) {
    final observed = data.completenessBuckets.fold<int>(
      0,
      (sum, bucket) => sum + bucket.observed,
    );
    final expected = data.completenessBuckets.fold<int>(
      0,
      (sum, bucket) => sum + bucket.expected,
    );
    return _CompletenessTotals(
      observed: observed,
      expected: expected,
      percent: expected == 0 ? 0 : (observed / expected * 100).round(),
    );
  }
}
