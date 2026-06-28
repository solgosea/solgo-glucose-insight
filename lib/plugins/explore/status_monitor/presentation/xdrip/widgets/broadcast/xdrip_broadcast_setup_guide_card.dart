import 'package:flutter/material.dart';

import '../../../widgets/detail/status_copyable_code_row.dart';
import '../../../styles/status_monitor_theme.dart';
import '../xdrip_detail_section_frame.dart';

class XdripBroadcastSetupGuideCard extends StatelessWidget {
  const XdripBroadcastSetupGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return XdripDetailSectionFrame(
      title: 'Broadcast setup guide',
      trailing: 'AAPS path',
      child: XdripGlassPanel(
        child: Column(
          children: [
            const _SetupStep(
              index: '1',
              title: 'Open xDrip+ Inter-app settings',
              body:
                  'In xDrip+, open Settings > Inter-app settings. This is the path AAPS uses when xDrip+ is selected as BG source.',
            ),
            const _SetupStep(
              index: '2',
              title: 'Enable local broadcast',
              body:
                  'Turn on Broadcast locally and Send the displayed glucose value so receivers get the same value xDrip+ shows.',
            ),
            const _SetupStep(
              index: '3',
              title: 'Enable compatible broadcast',
              body:
                  'Turn on Enable Compatible Broadcast. If xDrip+ asks for receiver packages, copy these exact values.',
            ),
            const SizedBox(height: 8),
            const StatusCopyableCodeRow(
              label: 'AAPS receiver package',
              value: 'info.nightscout.androidaps',
            ),
            const SizedBox(height: 8),
            const StatusCopyableCodeRow(
              label: 'SolgoInsight observer package',
              value: 'com.metaguru.smartxdrip',
            ),
            const SizedBox(height: 11),
            const _SetupStep(
              index: '4',
              title: 'Allow SolgoInsight observation',
              body:
                  'Return here after saving the xDrip+ settings. Status Monitor will mark the broadcast path healthy once a fresh BgEstimate arrives.',
              last: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  final String index;
  final String title;
  final String body;
  final bool last;

  const _SetupStep({
    required this.index,
    required this.title,
    required this.body,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: StatusMonitorTheme.teal.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: StatusMonitorTheme.teal.withOpacity(.24)),
            ),
            child: Center(
              child: Text(
                index,
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.teal,
                  fontSize: 10.5,
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
