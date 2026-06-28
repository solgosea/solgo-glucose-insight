import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../shared/status_probe_card.dart';

class StatusProbeChecklistFooterNote extends StatelessWidget {
  const StatusProbeChecklistFooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusProbeCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.blue.withOpacity(.10),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: StatusMonitorTheme.blue.withOpacity(.28)),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: StatusMonitorTheme.blue,
              size: 18,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'These checks help troubleshoot the data chain. They do not diagnose a sensor, a loop decision, or a medical condition.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: StatusMonitorTheme.soft,
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
