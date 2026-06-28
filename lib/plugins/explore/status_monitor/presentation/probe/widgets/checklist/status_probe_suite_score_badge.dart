import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../models/status_probe_score_vm.dart';
import '../../theme/status_probe_ui_theme.dart';

class StatusProbeSuiteScoreBadge extends StatelessWidget {
  final StatusProbeScoreVm score;
  final String tone;

  const StatusProbeSuiteScoreBadge({
    super.key,
    required this.score,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusProbeUiTheme.toneColor(tone);
    final displayColor = score.includedInCore ? color : StatusMonitorTheme.dim;
    final completed = score.totalCount > 0 &&
        score.yesCount + score.noCount >= score.totalCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 54, minHeight: 42),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: displayColor.withOpacity(.08),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: displayColor.withOpacity(.28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${score.score}',
                style: StatusProbeUiTheme.mono(
                  context,
                  size: 20,
                  weight: FontWeight.w900,
                  color: displayColor,
                ),
              ),
              Text(
                'score',
                style: StatusProbeUiTheme.mono(
                  context,
                  size: 8,
                  weight: FontWeight.w900,
                  color: StatusMonitorTheme.dim,
                ).copyWith(letterSpacing: .6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, size: 13, color: displayColor),
            const SizedBox(width: 4),
            Text(
              '${score.yesCount}/${score.totalCount}',
              style: StatusProbeUiTheme.mono(
                context,
                size: 12,
                weight: FontWeight.w900,
                color: displayColor,
              ),
            ),
          ],
        ),
        if (!completed) ...[
          const SizedBox(height: 6),
          SizedBox(
            width: 106,
            height: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: score.progress.clamp(0, 1),
                backgroundColor: StatusMonitorTheme.muted.withOpacity(.22),
                valueColor: AlwaysStoppedAnimation(displayColor),
              ),
            ),
          ),
        ],
        const SizedBox(height: 5),
        Text(
          score.noCount == 0 ? 'all yes' : '${score.noCount} no',
          style: StatusProbeUiTheme.mono(
            context,
            size: 8.5,
            color: StatusMonitorTheme.dim,
          ).copyWith(letterSpacing: .5),
        ),
      ],
    );
  }
}
