import 'package:flutter/material.dart';

import '../styles/status_monitor_theme.dart';

class StatusWidgetsNotificationsCard extends StatelessWidget {
  final VoidCallback onTap;

  const StatusWidgetsNotificationsCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: StatusMonitorTheme.cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: StatusMonitorTheme.green.withOpacity(.11),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.widgets_rounded,
                color: StatusMonitorTheme.green,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Widgets & Notifications',
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Home screen widgets and silent persistent notification',
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: StatusMonitorTheme.green,
            ),
          ],
        ),
      ),
    );
  }
}
