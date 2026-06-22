import 'package:flutter/material.dart';

import '../../models/status_dashboard_state.dart';
import '../setup_prompt/status_setup_prompt_bar.dart';
import '../status_summary_bar.dart';
import 'status_dashboard_components_section.dart';
import 'status_dashboard_footer.dart';
import 'status_dashboard_history_section.dart';
import 'status_dashboard_notice.dart';
import 'status_dashboard_tools_section.dart';

class StatusDashboardSections extends StatelessWidget {
  final StatusDashboardState state;
  final VoidCallback onOpenWidgets;
  final VoidCallback onOpenHistory;

  const StatusDashboardSections({
    super.key,
    required this.state,
    required this.onOpenWidgets,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = state.viewModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.notice != null)
          StatusDashboardNoticeBar(notice: state.notice!),
        if (state.setupPrompt != null)
          StatusSetupPromptBar(model: state.setupPrompt!),
        StatusSummaryBar(summary: viewModel.report.summary),
        StatusDashboardComponentsSection(components: viewModel.components),
        StatusDashboardToolsSection(onOpenWidgets: onOpenWidgets),
        const SizedBox(height: 12),
        StatusDashboardHistorySection(onOpenHistory: onOpenHistory),
        const StatusDashboardFooter(),
      ],
    );
  }
}
