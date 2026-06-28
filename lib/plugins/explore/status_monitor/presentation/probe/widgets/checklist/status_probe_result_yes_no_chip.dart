import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../theme/status_probe_ui_theme.dart';

class StatusProbeResultYesNoChip extends StatelessWidget {
  final bool yes;

  const StatusProbeResultYesNoChip({
    super.key,
    required this.yes,
  });

  @override
  Widget build(BuildContext context) {
    final color = yes ? StatusMonitorTheme.green : StatusMonitorTheme.amber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            yes ? Icons.check_rounded : Icons.close_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            yes ? 'Yes' : 'No',
            style: StatusProbeUiTheme.mono(
              context,
              size: 9,
              weight: FontWeight.w900,
              color: color,
            ).copyWith(letterSpacing: .4),
          ),
        ],
      ),
    );
  }
}
