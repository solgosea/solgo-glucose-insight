import 'package:flutter/material.dart';

import '../../../domain/hub/status_hub_enums.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubVisuals {
  const StatusHubVisuals._();

  static Color colorFor(StatusHubState state) {
    return switch (state) {
      StatusHubState.fresh => StatusMonitorTheme.green,
      StatusHubState.delayed => StatusMonitorTheme.amber,
      StatusHubState.stale ||
      StatusHubState.unavailable =>
        StatusMonitorTheme.rose,
      StatusHubState.limited => StatusMonitorTheme.blue,
      StatusHubState.notChecked ||
      StatusHubState.unknown =>
        StatusMonitorTheme.dim,
    };
  }

  /// User-facing severity word shown on the summary badge.
  /// Mirrors the HTML which shows `Watch` rather than the raw state name.
  static String displayLabelFor(StatusHubState state) {
    return switch (state) {
      StatusHubState.fresh => 'Fresh',
      StatusHubState.delayed => 'Watch',
      StatusHubState.stale || StatusHubState.unavailable => 'Issue',
      StatusHubState.limited ||
      StatusHubState.notChecked ||
      StatusHubState.unknown =>
        'Limited',
    };
  }

  static IconData iconForNode(StatusHubNodeId id) {
    return switch (id) {
      StatusHubNodeId.cgmSensor => Icons.sensors_rounded,
      StatusHubNodeId.juggluco => Icons.broadcast_on_personal_rounded,
      StatusHubNodeId.xdrip => Icons.hub_rounded,
      StatusHubNodeId.nightscout => Icons.cloud_done_rounded,
      StatusHubNodeId.aaps => Icons.loop_rounded,
      StatusHubNodeId.watch => Icons.watch_rounded,
      StatusHubNodeId.solgoObserver => Icons.visibility_rounded,
    };
  }
}

class StatusHubSectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;

  const StatusHubSectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.green,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.45,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.dim,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class StatusHubPill extends StatelessWidget {
  final String label;
  final StatusHubState state;

  const StatusHubPill({
    super.key,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.38)),
      ),
      child: Text(
        label,
        style: StatusMonitorTheme.mono.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
