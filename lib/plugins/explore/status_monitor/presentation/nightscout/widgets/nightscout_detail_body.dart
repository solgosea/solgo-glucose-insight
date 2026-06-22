import 'package:flutter/material.dart';

import '../../../domain/component_health.dart';
import '../../../domain/nightscout/nightscout_detail_data.dart';
import '../../styles/status_monitor_theme.dart';
import 'capability/nightscout_capability_context_card.dart';
import 'endpoint_matrix/nightscout_endpoint_matrix_card.dart';
import 'freshness/nightscout_server_freshness_card.dart';
import 'nightscout_signal_grid.dart';
import 'response_timeline/nightscout_response_timeline_card.dart';

class NightscoutDetailBody extends StatelessWidget {
  final ComponentHealth component;

  const NightscoutDetailBody({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final data = component.detailData;
    if (data is! NightscoutDetailData) {
      return NightscoutSignalGrid(component: component);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NightscoutEndpointMatrixCard(data: data),
              NightscoutResponseTimelineCard(data: data),
            ],
          ),
        ),
        NightscoutServerFreshnessCard(data: data),
        NightscoutCapabilityContextCard(data: data),
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
        'Status Monitor shows observable Nightscout API behavior. It does not diagnose hosting, database, or token configuration unless the HTTP response directly confirms it.',
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 11.5,
          height: 1.45,
        ),
      ),
    );
  }
}
