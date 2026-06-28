import 'package:flutter/material.dart';

import '../../../domain/component_health.dart';
import '../../../domain/xdrip/xdrip_detail_data.dart';
import '../../styles/status_monitor_theme.dart';
import 'broadcast/xdrip_broadcast_primary_card.dart';
import 'broadcast/xdrip_broadcast_setup_guide_card.dart';
import 'completeness/xdrip_completeness_heat_card.dart';
import 'freshness/xdrip_freshness_timeline_card.dart';
import 'service/xdrip_service_battery_card.dart';
import 'xdrip_signal_grid.dart';

class XdripDetailBody extends StatelessWidget {
  final ComponentHealth component;

  const XdripDetailBody({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final data = component.detailData;
    if (data is! XdripDetailData) {
      return XdripSignalGrid(component: component);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              XdripBroadcastPrimaryCard(
                readiness: data.broadcastReadiness,
              ),
              XdripFreshnessTimelineCard(data: data),
              XdripCompletenessHeatCard(data: data),
            ],
          ),
        ),
        XdripServiceBatteryCard(data: data),
        const XdripBroadcastSetupGuideCard(),
        const _NoticeCard(),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.blue.withOpacity(.06),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.20)),
      ),
      child: Text(
        'Status Monitor shows observable link health. xDrip+ remains the source of truth for collection, calibration, sensor handling, and primary alerts.',
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 11.5,
          height: 1.45,
        ),
      ),
    );
  }
}
