import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class StatusDashboardSectionLabel extends StatelessWidget {
  final String title;
  final String? trailing;

  const StatusDashboardSectionLabel({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.dim,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.green,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}
