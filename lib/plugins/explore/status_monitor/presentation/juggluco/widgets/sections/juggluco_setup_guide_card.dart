import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../../widgets/detail/status_copyable_code_row.dart';
import '../primitives/juggluco_detail_primitives.dart';

class JugglucoSetupGuideCard extends StatelessWidget {
  const JugglucoSetupGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: jugglucoCardDecoration(StatusMonitorTheme.teal),
      child: const Column(
        children: [
          JugglucoSetupStep(
            index: '1',
            title: 'Open Juggluco',
            body:
                'On the same phone, open Juggluco and confirm the current glucose screen is receiving fresh sensor data.',
          ),
          JugglucoSetupStep(
            index: '2',
            title: 'Find broadcast settings',
            body:
                'Open Juggluco broadcast settings and find the app/package allow list. Copy this exact receiver package if Juggluco asks for one.',
          ),
          SizedBox(height: 8),
          StatusCopyableCodeRow(
            label: 'SolgoInsight observer package',
            value: 'com.metaguru.smartxdrip',
          ),
          SizedBox(height: 9),
          JugglucoSetupStep(
            index: '3',
            title: 'Turn on the xDrip+ handoff',
            body:
                'Enable the Patched Libre or 640G/EverSense compatible path, then confirm the SolgoInsight package is allowed to receive it.',
          ),
          JugglucoSetupStep(
            index: '4',
            title: 'Return to SolgoInsight',
            body:
                'Keep Juggluco running, come back here, and wait for Juggluco and xDrip+ to show fresh observations.',
          ),
          JugglucoSetupStep(
            index: '5',
            title: 'Compare local and cloud freshness',
            body:
                'If Juggluco is fresh but Nightscout is delayed, check xDrip+ upload, network, token, and server availability.',
            last: true,
          ),
        ],
      ),
    );
  }
}

class JugglucoSetupStep extends StatelessWidget {
  final String index;
  final String title;
  final String body;
  final bool last;

  const JugglucoSetupStep({
    super.key,
    required this.index,
    required this.title,
    required this.body,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.teal.withOpacity(.10),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: StatusMonitorTheme.teal.withOpacity(.23),
              ),
            ),
            child: Center(
              child: Text(
                index,
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.teal,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
