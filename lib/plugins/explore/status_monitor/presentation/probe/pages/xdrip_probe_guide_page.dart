import 'package:flutter/material.dart';

import '../widgets/guide/status_probe_guide_components.dart';

class XdripProbeGuidePage extends StatelessWidget {
  const XdripProbeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusProbeGuideShell(
      eyebrow: 'xDrip+',
      title: 'xDrip+ setup',
      subtitle: 'Let Solgo Insight observe xDrip+',
      heroTitle: 'xDrip+ -> Solgo Insight',
      heroBody:
          'Use this when xDrip+ is the hub for CGM data, Nightscout upload, AAPS, Watch, or remote viewers. Solgo Insight only observes local evidence when xDrip+ publishes a new reading.',
      icon: Icons.sensors_rounded,
      children: [
        StatusProbeGuideSectionLabel(
          left: 'Solgo can check',
          right: 'run from checklist',
        ),
        StatusProbeCheckListCard(
          items: [
            StatusProbeCheckItem(
              title: 'xDrip+ package visibility',
              body: 'Checks whether xDrip+ can be found on this phone.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'PKG',
            ),
            StatusProbeCheckItem(
              title: 'BgEstimate broadcast',
              body: 'Listens for the xDrip+ local reading broadcast.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'BG',
            ),
            StatusProbeCheckItem(
              title: 'Broadcast freshness',
              body: 'Checks whether the latest local broadcast is recent.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'AGE',
            ),
            StatusProbeCheckItem(
              title: 'AAPS output evidence',
              body:
                  'Observes whether downstream evidence reports xDrip+ as BG source.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'SRC',
            ),
          ],
        ),
        StatusProbeGuideSectionLabel(
          left: 'Steps in xDrip+',
          right: 'local broadcast',
        ),
        StatusProbeSetupStepCard(
          number: 1,
          title: 'Open xDrip+ Settings',
          body:
              'Start from the main xDrip+ device that receives or stores the latest glucose readings.',
          pathLabel: 'Open',
          pathValue: 'xDrip+ -> Settings',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 2,
          title: 'Go to Inter-app settings',
          body: 'This is where xDrip+ provides local data to other apps.',
          pathLabel: 'Find',
          pathValue: 'Settings -> Inter-app settings',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 3,
          title: 'Enable local broadcast',
          body:
              'Turn on local broadcast so other apps can listen for new readings.',
          pathLabel: 'Turn on',
          pathValue: 'Enable local broadcast',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 4,
          title: 'Enable compatible broadcast if needed',
          body: 'This helps apps using the classic xDrip+ BgEstimate format.',
          pathLabel: 'Turn on if needed',
          pathValue: 'Compatible broadcast / xDrip-compatible format',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 5,
          title: 'Identify receiver',
          body:
              'Paste the Solgo Insight package name. If xDrip+ allows multiple packages, keep existing packages and add this one separated by a space.',
          pathLabel: 'Paste receiver package',
          pathValue: 'Identify receiver',
          code: 'com.metaguru.smartxdrip',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 6,
          title: 'Wait for the next reading',
          body:
              'Return to Solgo Insight and run the checklist again. A fresh reading usually arrives on the next CGM interval.',
        ),
        SizedBox(height: 12),
        StatusProbeGuideNote(
          title: 'Ready to monitor',
          body:
              'This only lets Solgo Insight observe local xDrip+ evidence. It does not replace xDrip+ or change how xDrip+ collects CGM data.',
          icon: Icons.verified_user_rounded,
        ),
      ],
    );
  }
}
