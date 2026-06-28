import 'package:flutter/material.dart';

import '../../../domain/component_health.dart';
import '../../../domain/watch/watch_detail_data.dart';
import '../../widgets/detail/status_detail_shared_widgets.dart';
import '../mappers/watch_detail_view_model_mapper.dart';
import 'watch_detail_hero_card.dart';
import 'watch_display_evidence_card.dart';
import 'watch_display_path_strip.dart';
import 'watch_display_service_card.dart';
import 'watch_optional_path_notice.dart';
import 'watch_path_checks_card.dart';
import 'watch_setup_guide_card.dart';

class WatchDetailBody extends StatelessWidget {
  final ComponentHealth component;
  final WatchDetailViewModelMapper mapper;

  const WatchDetailBody({
    super.key,
    required this.component,
    this.mapper = const WatchDetailViewModelMapper(),
  });

  @override
  Widget build(BuildContext context) {
    final data = component.detailData;
    if (data is! WatchDetailData) {
      return const SizedBox.shrink();
    }
    final vm = mapper.map(data);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WatchDetailHeroCard(viewModel: vm),
            WatchDisplayPathStrip(viewModel: vm),
            const StatusDetailSectionLabel(
              'Path checks',
              trailing: 'probe evidence',
            ),
            WatchPathChecksCard(checks: vm.pathChecks),
            const StatusDetailSectionLabel(
              'xDrip+ display service',
              trailing: 'watch requirement',
            ),
            WatchDisplayServiceCard(facts: vm.serviceFacts),
            const StatusDetailSectionLabel(
              'Watch evidence',
              trailing: 'optional downstream',
            ),
            WatchDisplayEvidenceCard(evidence: vm.displayEvidence),
            const StatusDetailSectionLabel('Setup guide', trailing: 'watch'),
            WatchSetupGuideCard(steps: vm.setupSteps),
            const WatchOptionalPathNotice(),
          ],
        ),
      ),
    );
  }
}
