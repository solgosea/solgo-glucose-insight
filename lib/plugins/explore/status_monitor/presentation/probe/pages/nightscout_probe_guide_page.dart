import 'package:flutter/material.dart';

import '../widgets/guide/status_probe_guide_components.dart';

class NightscoutProbeGuidePage extends StatelessWidget {
  const NightscoutProbeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusProbeGuideShell(
      eyebrow: 'Nightscout',
      title: 'Nightscout check',
      subtitle: 'Check whether cloud data is up to date',
      heroTitle: 'Is Nightscout behind?',
      heroBody:
          'Use this page when the phone has fresh xDrip+ readings but Nightscout appears delayed or missing recent data.',
      icon: Icons.cloud_done_rounded,
      children: [
        StatusProbeGuideSectionLabel(
          left: 'Solgo can check',
          right: 'run from checklist',
        ),
        StatusProbeCheckListCard(
          items: [
            StatusProbeCheckItem(
              title: 'Nightscout can be reached',
              body: 'Checks the private server without exposing URL or token.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'API',
            ),
            StatusProbeCheckItem(
              title: 'Latest cloud reading',
              body: 'Checks whether Nightscout entries are fresh.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'AGE',
            ),
            StatusProbeCheckItem(
              title: 'Device status visibility',
              body: 'Checks whether devicestatus evidence is available.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'DEV',
            ),
            StatusProbeCheckItem(
              title: 'Server response time',
              body:
                  'Checks whether Nightscout responds within the expected range.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'MS',
            ),
          ],
        ),
        StatusProbeGuideSectionLabel(
          left: 'Check in xDrip+ manually',
          right: 'cannot read directly',
        ),
        StatusProbeSetupStepCard(
          number: 1,
          title: 'Confirm Nightscout upload is enabled',
          body:
              'Solgo cannot safely read this xDrip+ setting directly. Open xDrip+ and verify that Nightscout upload is turned on for this data source.',
          pathLabel: 'Open',
          pathValue: 'xDrip+ -> Cloud upload / Nightscout sync',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 2,
          title: 'Confirm the saved URL and token',
          body:
              'Solgo can test the configured access, but it cannot see what xDrip+ has saved internally. Make sure xDrip+ is using the same Nightscout server.',
          pathLabel: 'Check',
          pathValue:
              'xDrip+ Nightscout URL, token, API secret, or upload settings',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 3,
          title: 'Save and wait for the next reading',
          body:
              'After changing upload settings, wait for the next CGM reading and run the connection checklist again.',
        ),
        SizedBox(height: 12),
        StatusProbeGuideNote(
          title: 'If Nightscout is not used',
          body:
              'You can ignore this page. A delayed Nightscout path does not mean the local xDrip+ path is broken.',
          icon: Icons.privacy_tip_rounded,
        ),
      ],
    );
  }
}
