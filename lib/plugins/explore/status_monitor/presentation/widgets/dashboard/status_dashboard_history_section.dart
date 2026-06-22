import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class StatusDashboardHistorySection extends StatelessWidget {
  final VoidCallback onOpenHistory;

  const StatusDashboardHistorySection({
    super.key,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpenHistory,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: StatusMonitorTheme.cardDecoration(),
        child: Row(
          children: [
            const Icon(Icons.history_rounded, color: StatusMonitorTheme.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '7-day status history - see when each component changed state',
                style: StatusMonitorTheme.inter.copyWith(
                  color: StatusMonitorTheme.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: StatusMonitorTheme.blue,
            ),
          ],
        ),
      ),
    );
  }
}
