import 'package:flutter/material.dart';

import '../../application/i18n/status_monitor_l10n.dart';
import '../styles/status_monitor_theme.dart';
import '../history/models/status_history_view_model.dart';
import '../history/widgets/status_component_history_section.dart';
import '../history/widgets/status_history_scope_note.dart';
import '../history/widgets/status_history_legend.dart';
import '../history/widgets/status_history_section_label.dart';

class StatusHistoryChart extends StatelessWidget {
  final StatusHistoryViewModel viewModel;

  const StatusHistoryChart({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.sections.isEmpty) {
      if (viewModel.loading) {
        return StatusEmptyHistory(
          message: context.statusMonitorL10n.pageHistoryLoadingComponent,
          loading: true,
        );
      }
      return const StatusEmptyHistory();
    }
    return Column(
      children: [
        const StatusHistoryScopeNote(),
        const StatusHistoryLegend(),
        for (final section in viewModel.sections) ...[
          StatusHistorySectionLabel(section.title),
          StatusComponentHistorySection(section: section),
        ],
      ],
    );
  }
}

class StatusEmptyHistory extends StatelessWidget {
  final String? message;
  final bool loading;

  const StatusEmptyHistory({
    super.key,
    this.message,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: StatusMonitorTheme.cardDecoration(),
      child: Row(
        children: [
          if (loading) ...[
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: StatusMonitorTheme.green,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message ??
                  'No status changes recorded yet. This page only records component-level changes, not every background refresh.',
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.soft,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
