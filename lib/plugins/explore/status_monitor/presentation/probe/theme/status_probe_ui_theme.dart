import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';

class StatusProbeUiTheme {
  static Color toneColor(String tone) {
    return switch (tone) {
      'healthy' => StatusMonitorTheme.green,
      'watch' => StatusMonitorTheme.amber,
      'issue' => StatusMonitorTheme.rose,
      'unknown' => StatusMonitorTheme.blue,
      _ => StatusMonitorTheme.dim,
    };
  }

  static BoxDecoration probeCard() {
    return BoxDecoration(
      color: StatusMonitorTheme.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: StatusMonitorTheme.border),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x0AFFFFFF), Color(0x03FFFFFF)],
      ),
    );
  }

  static TextStyle mono(
    BuildContext context, {
    double size = 11,
    FontWeight weight = FontWeight.w800,
    Color color = StatusMonitorTheme.text,
  }) {
    return StatusMonitorTheme.mono.copyWith(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}
