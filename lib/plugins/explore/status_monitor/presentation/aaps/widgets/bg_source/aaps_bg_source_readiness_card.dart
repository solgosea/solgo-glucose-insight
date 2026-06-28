import 'package:flutter/material.dart';

import '../../../../domain/xdrip/xdrip_broadcast_readiness.dart';
import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_copyable_code_row.dart';
import '../aaps_detail_section_frame.dart';

class AapsBgSourceReadinessCard extends StatelessWidget {
  final XdripBroadcastReadiness readiness;

  const AapsBgSourceReadinessCard({super.key, required this.readiness});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(readiness.level);
    return AapsDetailSectionFrame(
      title: 'BG source readiness',
      trailing: 'xDrip+ path',
      child: AapsGlassPanel(
        level: readiness.level,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withOpacity(.28)),
                  ),
                  child: Icon(
                    Icons.sync_alt_rounded,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        readiness.stateLabel,
                        style: StatusMonitorTheme.inter.copyWith(
                          color: color,
                          fontSize: 21,
                          height: 1.06,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'xDrip+ broadcast latest ${readiness.latestLabel}. AAPS does not use xDrip+ Web Server for this BG source path.',
                        style: StatusMonitorTheme.inter.copyWith(
                          color: StatusMonitorTheme.soft,
                          fontSize: 11.4,
                          height: 1.38,
                        ),
                      ),
                    ],
                  ),
                ),
                AapsBadge(label: readiness.stateLabel, level: readiness.level),
              ],
            ),
            const SizedBox(height: 13),
            StatusCopyableCodeRow(
              label: 'AAPS receiver',
              value: readiness.receiverPackage,
            ),
            const SizedBox(height: 8),
            const StatusCopyableCodeRow(
              label: 'SolgoInsight observer',
              value: 'com.metaguru.smartxdrip',
            ),
          ],
        ),
      ),
    );
  }
}
