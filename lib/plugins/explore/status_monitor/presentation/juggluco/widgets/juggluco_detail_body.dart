import 'package:flutter/material.dart';

import '../../../domain/component_health.dart';
import '../../../domain/juggluco/juggluco_detail_data.dart';
import '../../widgets/detail/status_detail_shared_widgets.dart';
import 'sections/juggluco_broadcast_freshness_card.dart';
import 'sections/juggluco_chain_checks_card.dart';
import 'sections/juggluco_hero_card.dart';
import 'sections/juggluco_notice_card.dart';
import 'sections/juggluco_primary_evidence_grid.dart';
import 'sections/juggluco_setup_guide_card.dart';

class JugglucoDetailBody extends StatelessWidget {
  final ComponentHealth component;

  const JugglucoDetailBody({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final data = component.detailData;
    if (data is! JugglucoDetailData) {
      return const SizedBox.shrink();
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JugglucoHeroCard(component: component, data: data),
            StatusDetailSectionLabel(
              'Primary evidence',
              trailing: 'broadcast path',
            ),
            JugglucoPrimaryEvidenceGrid(data: data),
            StatusDetailSectionLabel('Broadcast freshness',
                trailing: 'last 24h'),
            JugglucoBroadcastFreshnessCard(data: data),
            StatusDetailSectionLabel(
              'Chain checks',
              trailing: 'where to look first',
            ),
            JugglucoChainChecksCard(data: data),
            StatusDetailSectionLabel('Setup guide', trailing: 'required'),
            const JugglucoSetupGuideCard(),
            const JugglucoNoticeCard(),
          ],
        ),
      ),
    );
  }
}
