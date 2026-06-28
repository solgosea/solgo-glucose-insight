import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../models/status_probe_suite_card_vm.dart';
import '../shared/status_probe_card.dart';
import 'status_probe_result_check_row.dart';
import 'status_probe_suite_progress_header.dart';

class StatusProbeSuiteSection extends StatelessWidget {
  final StatusProbeSuiteCardVm suite;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onOpenGuide;

  const StatusProbeSuiteSection({
    super.key,
    required this.suite,
    required this.expanded,
    required this.onToggle,
    required this.onOpenGuide,
  });

  @override
  Widget build(BuildContext context) {
    return StatusProbeCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: StatusProbeSuiteProgressHeader(
              suite: suite,
              expanded: expanded,
              onToggle: onToggle,
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Column(
                    children: [
                      const Divider(
                        height: 1,
                        color: StatusMonitorTheme.line,
                      ),
                      ...suite.results.map(
                        (result) => Column(
                          children: [
                            StatusProbeResultCheckRow(
                              result: result,
                              onOpenGuide: onOpenGuide,
                            ),
                            if (result != suite.results.last)
                              Divider(
                                height: 1,
                                color: StatusMonitorTheme.line.withOpacity(.55),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
