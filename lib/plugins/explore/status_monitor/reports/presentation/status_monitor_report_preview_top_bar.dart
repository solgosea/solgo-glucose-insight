import 'package:flutter/material.dart';

import '../../application/i18n/status_monitor_l10n.dart';

class StatusMonitorReportPreviewTopBar extends StatelessWidget {
  final bool exporting;
  final VoidCallback onBack;
  final VoidCallback onPrint;
  final VoidCallback onShare;

  const StatusMonitorReportPreviewTopBar({
    super.key,
    required this.exporting,
    required this.onBack,
    required this.onPrint,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Row(
      children: [
        IconButton(
          onPressed: exporting ? null : onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        Expanded(
          child: Text(
            l10n.reportSupportTitle,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        TextButton.icon(
          onPressed: exporting ? null : onPrint,
          icon: const Icon(Icons.print_rounded, size: 18),
          label: Text(l10n.reportPrint),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: exporting ? null : onShare,
          icon: exporting
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.ios_share_rounded, size: 18),
          label: Text(l10n.reportShare),
        ),
      ],
    );
  }
}
