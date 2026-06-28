import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../models/status_probe_suite_progress_vm.dart';
import '../../theme/status_probe_ui_theme.dart';

class StatusProbeSuiteProgressBar extends StatelessWidget {
  final StatusProbeSuiteProgressVm progress;
  final String tone;

  const StatusProbeSuiteProgressBar({
    super.key,
    required this.progress,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusProbeUiTheme.toneColor(tone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                progress.runningCount > 0 ? 'Running checks' : 'Run progress',
                style: StatusProbeUiTheme.mono(
                  context,
                  size: 9,
                  weight: FontWeight.w900,
                  color: StatusMonitorTheme.dim,
                ).copyWith(letterSpacing: .5),
              ),
            ),
            Text(
              progress.label,
              style: StatusProbeUiTheme.mono(
                context,
                size: 9,
                weight: FontWeight.w900,
                color: StatusMonitorTheme.soft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.percent.clamp(0, 1),
            minHeight: 6,
            color: color,
            backgroundColor: StatusMonitorTheme.muted.withOpacity(.18),
          ),
        ),
      ],
    );
  }
}
