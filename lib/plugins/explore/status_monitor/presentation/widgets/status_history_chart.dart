import 'package:flutter/material.dart';

import '../styles/status_monitor_theme.dart';
import '../history/models/status_history_view_model.dart';
import '../history/widgets/status_component_history_card.dart';
import '../history/widgets/status_history_scope_note.dart';
import '../history/widgets/status_history_legend.dart';
import '../history/widgets/status_history_section_label.dart';

class StatusHistoryChart extends StatelessWidget {
  final StatusHistoryViewModel viewModel;

  const StatusHistoryChart({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.components.isEmpty) {
      return const StatusEmptyHistory();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.title,
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                viewModel.subtitle,
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const StatusHistoryScopeNote(),
        const StatusHistoryLegend(),
        for (final component in viewModel.components) ...[
          StatusHistorySectionLabel(component.title),
          StatusComponentHistoryCard(component: component),
        ],
      ],
    );
  }
}

class StatusEmptyHistory extends StatelessWidget {
  const StatusEmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: StatusMonitorTheme.cardDecoration(),
      child: Text(
        'No status changes recorded yet. This page only records component-level changes, not every background refresh.',
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 13,
          height: 1.4,
        ),
      ),
    );
  }
}
