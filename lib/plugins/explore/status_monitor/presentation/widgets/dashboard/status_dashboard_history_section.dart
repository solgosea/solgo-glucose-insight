import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../styles/status_monitor_theme.dart';

class StatusDashboardHistorySection extends StatelessWidget {
  final VoidCallback onOpenHistory;

  const StatusDashboardHistorySection({
    super.key,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return InkWell(
      onTap: onOpenHistory,
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
                color: StatusMonitorTheme.blue.withOpacity(.11),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: StatusMonitorTheme.blue,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pageSevenDayHistory,
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.pageSevenDayHistorySubtitle,
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
              color: StatusMonitorTheme.blue,
            ),
          ],
        ),
      ),
    );
  }
}
