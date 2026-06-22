import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class StatusHistorySectionLabel extends StatelessWidget {
  final String text;

  const StatusHistorySectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Text(
        text.toUpperCase(),
        style: StatusMonitorTheme.mono.copyWith(
          color: StatusMonitorTheme.dim,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}
