import 'package:flutter/material.dart';

import '../../../../domain/juggluco/juggluco_detail_data.dart';
import '../../../../domain/juggluco/juggluco_path_state.dart';
import '../../../styles/status_monitor_theme.dart';
import '../primitives/juggluco_detail_primitives.dart';

class JugglucoChainChecksCard extends StatelessWidget {
  final JugglucoDetailData data;

  const JugglucoChainChecksCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: jugglucoCardDecoration(StatusMonitorTheme.teal),
      child: Column(
        children: [
          JugglucoCheckRow(
            index: '1',
            title: 'Juggluco -> xDrip+ path',
            body: data.pathState == JugglucoPathState.fresh
                ? 'xDrip-compatible primary path is flowing.'
                : data.pathState == JugglucoPathState.waitingForFirstBroadcast
                    ? 'Receiver is ready. Waiting for Juggluco data.'
                    : data.pathState == JugglucoPathState.directOnly
                        ? 'Only direct Glucodata broadcast is visible so far.'
                        : data.pathState == JugglucoPathState.notConfigured
                            ? 'Broadcast setup is still needed.'
                            : 'Primary path needs attention.',
            badge: data.stateLabel,
            color: jugglucoStateColor(data.pathState),
          ),
          JugglucoCheckRow(
            index: '2',
            title: 'Juggluco direct broadcast',
            body: 'Observed paths: ${data.observedPathLabel}.',
            badge: 'Compare',
            color: StatusMonitorTheme.teal,
          ),
          JugglucoCheckRow(
            index: '3',
            title: 'xDrip+ / Nightscout handoff',
            body:
                'xDrip+: ${data.chainComparison.xdripAgeLabel}. Nightscout: ${data.chainComparison.nightscoutAgeLabel}.',
            badge: 'Focus',
            color: StatusMonitorTheme.amber,
            last: true,
          ),
        ],
      ),
    );
  }
}
