import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../theme/status_probe_ui_theme.dart';

class StatusProbeSectionTitle extends StatelessWidget {
  final String left;
  final String right;

  const StatusProbeSectionTitle({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      child: Row(
        children: [
          Text(
            left.toUpperCase(),
            style: StatusProbeUiTheme.mono(
              context,
              size: 10,
              weight: FontWeight.w900,
              color: StatusMonitorTheme.green,
            ).copyWith(letterSpacing: 1.1),
          ),
          const Spacer(),
          Text(
            right,
            style: StatusProbeUiTheme.mono(
              context,
              size: 10,
              color: StatusMonitorTheme.dim,
            ),
          ),
        ],
      ),
    );
  }
}
