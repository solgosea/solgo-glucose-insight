import 'package:flutter/material.dart';

import '../../application/i18n/status_monitor_l10n.dart';
import '../styles/status_monitor_theme.dart';

class StatusMonitorFloatingPermissionPrompt extends StatelessWidget {
  final bool granted;
  final VoidCallback onRequest;

  const StatusMonitorFloatingPermissionPrompt({
    super.key,
    required this.granted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    if (granted) {
      return Text(
        l10n.pageFloatingPermissionReady,
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.green,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
        ),
      );
    }
    return TextButton.icon(
      onPressed: onRequest,
      icon: const Icon(Icons.open_in_new_rounded, size: 15),
      label: Text(l10n.pageEnableFloatingPermission),
      style: TextButton.styleFrom(
        foregroundColor: StatusMonitorTheme.green,
        padding: EdgeInsets.zero,
        textStyle: StatusMonitorTheme.inter.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
