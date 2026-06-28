import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class StatusHubEmptyState extends StatelessWidget {
  final bool loading;
  final Object? error;

  const StatusHubEmptyState({
    super.key,
    required this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 0),
      child: Container(
        decoration: StatusMonitorTheme.glassCardDecoration(),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  color: StatusMonitorTheme.green,
                  strokeWidth: 3,
                ),
              )
            else
              const Icon(
                Icons.hub_rounded,
                color: StatusMonitorTheme.green,
                size: 36,
              ),
            const SizedBox(height: 14),
            Text(
              loading ? 'Building xDrip+ hub view' : 'No hub evidence yet',
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.text,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error == null
                  ? 'Run Status Monitor checks first, then return here to review the observed connection path.'
                  : 'Could not build the hub view: $error',
              textAlign: TextAlign.center,
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.soft,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
