import 'package:flutter/material.dart';

import '../../../domain/aaps/aaps_detail_data.dart';
import '../../../domain/component_health.dart';
import 'context/aaps_iob_cob_profile_panel.dart';
import 'context/aaps_pump_loop_context_cards.dart';
import 'evidence/aaps_evidence_matrix_card.dart';
import 'timeline/aaps_loop_evidence_timeline_card.dart';

export 'notice/aaps_safety_notice.dart';

class AapsDetailBody extends StatelessWidget {
  final ComponentHealth component;

  const AapsDetailBody({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    final data = component.detailData;
    if (data is! AapsDetailData) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AapsLoopEvidenceTimelineCard(data: data),
              AapsEvidenceMatrixCard(data: data),
            ],
          ),
        ),
        AapsPumpLoopContextCards(data: data),
        AapsIobCobProfilePanel(data: data),
      ],
    );
  }
}
