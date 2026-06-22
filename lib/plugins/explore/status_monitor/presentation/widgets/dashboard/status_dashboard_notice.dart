import 'package:flutter/material.dart';

import '../../models/status_dashboard_state.dart';
import '../../styles/status_monitor_theme.dart';

class StatusDashboardNoticeBar extends StatelessWidget {
  final StatusDashboardNotice notice;

  const StatusDashboardNoticeBar({
    super.key,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: StatusMonitorTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: notice.accentColor.withOpacity(.32)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: notice.accentColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(notice.icon, color: notice.accentColor, size: 19),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.text,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notice.body,
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 11.8,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
