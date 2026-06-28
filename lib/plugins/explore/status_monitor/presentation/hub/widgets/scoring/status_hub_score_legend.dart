import 'package:flutter/material.dart';

import '../status_hub_visuals.dart';
import '../../../../domain/hub/status_hub_enums.dart';
import '../../../styles/status_monitor_theme.dart';

class StatusHubScoreLegend extends StatelessWidget {
  const StatusHubScoreLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _LegendItem(label: '85+', state: StatusHubState.fresh),
        _LegendItem(label: '65-84', state: StatusHubState.delayed),
        _LegendItem(label: '40-64', state: StatusHubState.limited),
        _LegendItem(label: '<40', state: StatusHubState.stale),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final StatusHubState state;

  const _LegendItem({required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(state);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: StatusMonitorTheme.mono.copyWith(
            color: StatusMonitorTheme.dim,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
