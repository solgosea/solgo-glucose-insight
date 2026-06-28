import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../models/status_probe_checklist_view_model.dart';
import '../../theme/status_probe_ui_theme.dart';
import '../shared/status_probe_card.dart';
import '../shared/status_probe_icon_badge.dart';
import 'status_probe_checklist_run_button.dart';
import 'status_probe_checklist_summary_strip.dart';

class StatusProbeChecklistHeader extends StatelessWidget {
  final StatusProbeChecklistViewModel viewModel;
  final VoidCallback onRun;

  const StatusProbeChecklistHeader({
    super.key,
    required this.viewModel,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    return StatusProbeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusProbeIconBadge(
                tone: 'healthy',
                icon: Icons.fact_check_rounded,
                text: 'PB',
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.heroTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: StatusMonitorTheme.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      viewModel.heroBody,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: StatusMonitorTheme.soft,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ReadyPill(score: viewModel.summary.coreScore),
            ],
          ),
          const SizedBox(height: 14),
          StatusProbeChecklistSummaryStrip(summary: viewModel.summary),
          if (viewModel.loading) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: StatusMonitorTheme.muted,
                valueColor: AlwaysStoppedAnimation(
                  StatusMonitorTheme.green,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          StatusProbeChecklistRunButton(
            loading: viewModel.loading,
            onRun: onRun,
          ),
        ],
      ),
    );
  }
}

class _ReadyPill extends StatelessWidget {
  final int score;

  const _ReadyPill({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.green.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusMonitorTheme.green.withOpacity(.28)),
      ),
      child: Text(
        score == 0 ? 'Ready' : '$score',
        style: StatusProbeUiTheme.mono(
          context,
          size: 10,
          weight: FontWeight.w900,
          color: StatusMonitorTheme.green,
        ),
      ),
    );
  }
}
