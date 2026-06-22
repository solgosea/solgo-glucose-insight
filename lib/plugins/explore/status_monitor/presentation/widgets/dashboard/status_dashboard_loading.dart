import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class StatusDashboardLoading extends StatelessWidget {
  const StatusDashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 140),
      child: Center(
        child: CircularProgressIndicator(
          color: StatusMonitorTheme.green,
        ),
      ),
    );
  }
}
