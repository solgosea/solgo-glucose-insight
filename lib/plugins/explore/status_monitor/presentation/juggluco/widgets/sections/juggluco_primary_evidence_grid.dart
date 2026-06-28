import 'package:flutter/material.dart';

import '../../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../styles/status_monitor_theme.dart';
import '../primitives/juggluco_detail_primitives.dart';

class JugglucoPrimaryEvidenceGrid extends StatelessWidget {
  final JugglucoDetailData data;

  const JugglucoPrimaryEvidenceGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      JugglucoEvidenceTile(
        label: 'Broadcast state',
        value: data.stateLabel,
        color: jugglucoStateColor(data.pathState),
        body: 'Latest Juggluco broadcast status.',
      ),
      JugglucoEvidenceTile(
        label: 'Latest reading',
        value: data.latestGlucoseLabel,
        color: jugglucoStateColor(data.pathState),
        body: 'Newest xDrip-compatible glucose payload, ${data.latestLabel}.',
      ),
      JugglucoEvidenceTile(
        label: 'Observed path',
        value: _primaryObservedPath(data.observedPathLabel),
        color: StatusMonitorTheme.teal,
        body: 'Broadcast paths seen: ${data.observedPathLabel}.',
      ),
      JugglucoEvidenceTile(
        label: 'Direct broadcast',
        value: _directObservedPath(data.observedPathLabel),
        color: data.xdripCompatiblePathObserved
            ? StatusMonitorTheme.green
            : StatusMonitorTheme.blue,
        body: data.xdripCompatiblePathObserved
            ? 'Primary xDrip+ handoff path is visible.'
            : 'Solgo Insight direct observation is available when present.',
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: jugglucoCardDecoration(StatusMonitorTheme.green),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const gap = 9.0;
            final columns = constraints.maxWidth < 360 ? 1 : 2;
            final tileWidth =
                (constraints.maxWidth - (columns - 1) * gap) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final tile in tiles)
                  SizedBox(
                    width: tileWidth,
                    height: columns == 1 ? 102 : 96,
                    child: tile,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _primaryObservedPath(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('patched libre')) return 'Patched Libre';
    if (lower.contains('640g') || lower.contains('eversense')) {
      return '640G/EverSense';
    }
    if (lower.contains('glucodata')) return 'Glucodata';
    return label;
  }

  String _directObservedPath(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('glucodata')) return 'Glucodata';
    if (lower.contains('patched libre') ||
        lower.contains('640g') ||
        lower.contains('eversense')) {
      return 'xDrip+ path';
    }
    return 'Pending';
  }
}
