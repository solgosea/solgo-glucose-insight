import 'package:flutter/material.dart';

import '../../application/i18n/status_monitor_l10n.dart';

class StatusMonitorReportPreviewError extends StatelessWidget {
  final VoidCallback onRetry;

  const StatusMonitorReportPreviewError({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 38),
            const SizedBox(height: 12),
            Text(
              l10n.reportCouldNotBuildPreview,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(l10n.reportTryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
