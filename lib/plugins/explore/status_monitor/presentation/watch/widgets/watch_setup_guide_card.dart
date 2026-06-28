import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../models/watch_detail_view_model.dart';
import 'primitives/watch_detail_primitives.dart';

class WatchSetupGuideCard extends StatelessWidget {
  final List<WatchSetupStepViewModel> steps;

  const WatchSetupGuideCard({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: watchCardDecoration(),
      child: Column(
        children: [
          for (var index = 0; index < steps.length; index++)
            _StepRow(step: steps[index], last: index == steps.length - 1),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final WatchSetupStepViewModel step;
  final bool last;

  const _StepRow({required this.step, required this.last});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: last ? 0 : 12, top: last ? 0 : 12),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: StatusMonitorTheme.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.blue.withOpacity(.10),
              borderRadius: BorderRadius.circular(11),
              border:
                  Border.all(color: StatusMonitorTheme.blue.withOpacity(.24)),
            ),
            child: Center(
              child: Text(
                step.index,
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 12.5,
                    height: 1.24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  step.body,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11,
                    height: 1.42,
                  ),
                ),
                if (step.settingPath != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                    decoration: BoxDecoration(
                      color: StatusMonitorTheme.amber.withOpacity(.08),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: StatusMonitorTheme.amber.withOpacity(.25),
                      ),
                    ),
                    child: Text(
                      step.settingPath!,
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.text,
                        fontSize: 10,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
