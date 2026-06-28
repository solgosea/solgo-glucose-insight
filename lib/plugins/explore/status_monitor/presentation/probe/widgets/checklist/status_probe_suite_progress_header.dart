import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../models/status_probe_suite_card_vm.dart';
import '../shared/status_probe_icon_badge.dart';
import 'status_probe_suite_progress_bar.dart';
import 'status_probe_suite_score_badge.dart';

class StatusProbeSuiteProgressHeader extends StatelessWidget {
  final StatusProbeSuiteCardVm suite;
  final bool expanded;
  final VoidCallback onToggle;

  const StatusProbeSuiteProgressHeader({
    super.key,
    required this.suite,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 460;
            final title = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusProbeIconBadge(
                  tone: suite.tone,
                  icon: Icons.fact_check_rounded,
                  text: suite.initials,
                  size: 44,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suite.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: StatusMonitorTheme.text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  height: 1.12,
                                ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        suite.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: StatusMonitorTheme.soft,
                              fontSize: 11,
                              height: 1.36,
                            ),
                      ),
                      if (suite.chips.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            _MiniChip(
                              label: suite.roleLabel,
                              highlighted: suite.roleLabel == 'CORE',
                            ),
                            _MiniChip(
                              label: suite.activationLabel,
                              highlighted: suite.active,
                            ),
                            ...suite.chips.map((chip) => _MiniChip(label: chip))
                          ],
                        ),
                      ],
                      if (suite.running ||
                          suite.progress.completedCount <
                              suite.progress.totalCount) ...[
                        const SizedBox(height: 10),
                        StatusProbeSuiteProgressBar(
                          progress: suite.progress,
                          tone: suite.tone,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
            final scoreAndToggle = Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusProbeSuiteScoreBadge(
                  score: suite.score,
                  tone: suite.tone,
                ),
                const SizedBox(width: 6),
                _ExpandButton(expanded: expanded),
              ],
            );
            if (narrow) {
              return Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: title),
                        const SizedBox(width: 8),
                        _ExpandButton(expanded: expanded),
                      ],
                    ),
                    const SizedBox(height: 12),
                    StatusProbeSuiteScoreBadge(
                      score: suite.score,
                      tone: suite.tone,
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 12),
                  scoreAndToggle,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  final bool expanded;

  const _ExpandButton({required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: StatusMonitorTheme.bg.withOpacity(.18),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: StatusMonitorTheme.line.withOpacity(.52)),
      ),
      child: AnimatedRotation(
        turns: expanded ? .5 : 0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: StatusMonitorTheme.soft,
          size: 16,
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final bool highlighted;

  const _MiniChip({
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.bg.withOpacity(.36),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlighted
              ? StatusMonitorTheme.green.withOpacity(.32)
              : StatusMonitorTheme.muted.withOpacity(.22),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color:
              highlighted ? StatusMonitorTheme.green : StatusMonitorTheme.soft,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          fontFamily: 'JetBrains Mono',
        ),
      ),
    );
  }
}
