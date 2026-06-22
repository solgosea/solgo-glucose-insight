import 'package:flutter/material.dart';

import '../../controllers/status_dashboard_controller.dart';
import 'status_dashboard_sections.dart';

class StatusDashboardContent extends StatelessWidget {
  final StatusDashboardController controller;
  final VoidCallback onOpenWidgets;
  final VoidCallback onOpenHistory;

  const StatusDashboardContent({
    super.key,
    required this.controller,
    required this.onOpenWidgets,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    return StatusDashboardSections(
      state: controller.dashboardState,
      onOpenWidgets: onOpenWidgets,
      onOpenHistory: onOpenHistory,
    );
  }
}
