import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../models/status_probe_checklist_summary_vm.dart';
import '../../theme/status_probe_ui_theme.dart';

class StatusProbeChecklistSummaryStrip extends StatelessWidget {
  final StatusProbeChecklistSummaryVm summary;

  const StatusProbeChecklistSummaryStrip({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final tablet = width >= StatusMonitorTheme.tabletBreakpoint;
    final stats = [
      ('${summary.coreScore}', 'Core score'),
      (summary.passing, 'Core checks'),
      (summary.optionalPaths, 'Optional paths'),
      (summary.lastChecked, 'Last checked'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: tablet ? 4 : 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
        childAspectRatio: tablet ? 1.7 : 2.2,
      ),
      itemBuilder: (context, index) {
        final item = stats[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: StatusMonitorTheme.bg.withOpacity(.38),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: StatusMonitorTheme.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.$1,
                style: StatusProbeUiTheme.mono(
                  context,
                  size: 18,
                  weight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.$2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 10.5,
                      height: 1.25,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
