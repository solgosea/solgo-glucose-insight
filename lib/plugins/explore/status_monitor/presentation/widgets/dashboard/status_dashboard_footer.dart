import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class StatusDashboardFooter extends StatelessWidget {
  const StatusDashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Text(
        'Free forever. By default, status is computed on your device. Server-side checks should be separate opt-in.',
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.dim,
          fontSize: 11.5,
          height: 1.4,
        ),
      ),
    );
  }
}
