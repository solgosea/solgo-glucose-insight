import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHistoryScopeNote extends StatelessWidget {
  const StatusHistoryScopeNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.blue.withOpacity(.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StatusMonitorTheme.blue.withOpacity(.18)),
      ),
      child: Text(
        l10n.pageHistoryScopeNote,
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.soft,
          fontSize: 11.5,
          height: 1.35,
        ),
      ),
    );
  }
}
