import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../status_widgets_notifications_card.dart';
import 'status_dashboard_section_label.dart';

class StatusDashboardToolsSection extends StatelessWidget {
  final VoidCallback onOpenWidgets;

  const StatusDashboardToolsSection({
    super.key,
    required this.onOpenWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusDashboardSectionLabel(title: l10n.pageWidgetsTitle),
        StatusWidgetsNotificationsCard(onTap: onOpenWidgets),
      ],
    );
  }
}
