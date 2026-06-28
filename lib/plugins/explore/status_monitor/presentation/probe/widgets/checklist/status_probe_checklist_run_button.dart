import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';

class StatusProbeChecklistRunButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onRun;

  const StatusProbeChecklistRunButton({
    super.key,
    required this.loading,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: loading ? null : onRun,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(42),
        backgroundColor: StatusMonitorTheme.green.withOpacity(.14),
        foregroundColor: StatusMonitorTheme.green,
        disabledBackgroundColor: StatusMonitorTheme.muted.withOpacity(.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: StatusMonitorTheme.green.withOpacity(.35),
          ),
        ),
      ),
      icon: loading
          ? const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: StatusMonitorTheme.green,
              ),
            )
          : const Icon(Icons.play_arrow_rounded),
      label: Text(loading ? 'Running...' : 'Run checks'),
    );
  }
}
