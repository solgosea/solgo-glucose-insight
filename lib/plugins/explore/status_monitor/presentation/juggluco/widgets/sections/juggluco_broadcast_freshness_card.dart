import 'package:flutter/material.dart';

import '../../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../primitives/juggluco_detail_primitives.dart';

class JugglucoBroadcastFreshnessCard extends StatelessWidget {
  final JugglucoDetailData data;

  const JugglucoBroadcastFreshnessCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const bucketCount = 48;
    final source = data.timeline.take(bucketCount).toList(growable: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: jugglucoCardDecoration(StatusMonitorTheme.green),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'xDrip-compatible latest ${data.latestLabel}',
                style: StatusMonitorTheme.mono.copyWith(
                  color: jugglucoStateColor(data.pathState),
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              Text(
                'Now',
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cellWidth =
                  (constraints.maxWidth - (bucketCount - 1) * 2) / bucketCount;
              return Wrap(
                spacing: 2,
                runSpacing: 2,
                children: [
                  for (var i = 0; i < bucketCount; i++)
                    Container(
                      width: cellWidth.clamp(3, 18).toDouble(),
                      height: 42,
                      decoration: BoxDecoration(
                        color: i >= source.length
                            ? StatusMonitorTheme.muted.withOpacity(.18)
                            : jugglucoStateColor(source[i].state).withOpacity(
                                source[i].state == data.pathState ? .58 : .34,
                              ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: const [
              JugglucoLegendDot(
                  label: 'fresh', color: StatusMonitorTheme.green),
              JugglucoLegendDot(
                  label: 'delayed', color: StatusMonitorTheme.amber),
              JugglucoLegendDot(
                  label: 'direct only', color: StatusMonitorTheme.amber),
              JugglucoLegendDot(label: 'stale', color: StatusMonitorTheme.rose),
              JugglucoLegendDot(
                  label: 'unknown', color: StatusMonitorTheme.muted),
            ],
          ),
        ],
      ),
    );
  }
}
