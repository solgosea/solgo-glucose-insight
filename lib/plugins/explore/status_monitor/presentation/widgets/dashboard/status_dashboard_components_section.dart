import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../models/status_view_models.dart';
import '../status_component_card.dart';
import 'status_dashboard_section_label.dart';

class StatusDashboardComponentsSection extends StatelessWidget {
  final List<StatusDashboardComponentViewModel> components;

  const StatusDashboardComponentsSection({
    super.key,
    required this.components,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusDashboardSectionLabel(
          title: l10n.pageComponents,
          trailing: l10n.pageRefreshNow,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          child: GridView.builder(
            itemCount: components.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 114,
            ),
            itemBuilder: (context, index) {
              return StatusComponentCard(
                viewModel: components[index],
                margin: EdgeInsets.zero,
                showSummary: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
