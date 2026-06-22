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
        for (final component in components)
          StatusComponentCard(viewModel: component),
      ],
    );
  }
}
