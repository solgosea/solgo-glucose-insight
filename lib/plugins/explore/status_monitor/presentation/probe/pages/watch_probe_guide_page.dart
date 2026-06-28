import 'package:flutter/material.dart';

import '../widgets/guide/status_probe_guide_components.dart';

class WatchProbeGuidePage extends StatelessWidget {
  const WatchProbeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusProbeGuideShell(
      eyebrow: 'Watch display',
      title: 'WatchDrip setup',
      subtitle: 'Make sure the watch path can receive xDrip+ data',
      heroTitle: 'Keep watch data visible',
      heroBody:
          'Use this page only if you rely on WatchDrip or another watch display to see glucose values without opening the phone.',
      icon: Icons.watch_rounded,
      children: [
        StatusProbeGuideSectionLabel(
          left: 'Solgo can check',
          right: 'run from checklist',
        ),
        StatusProbeCheckListCard(
          items: [
            StatusProbeCheckItem(
              title: 'Watch bridge package',
              body: 'Checks whether a known watch bridge can be found.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'PKG',
            ),
            StatusProbeCheckItem(
              title: 'Watch display evidence',
              body:
                  'Looks for safe observable evidence that the watch path is active.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'DSP',
            ),
          ],
        ),
        StatusProbeGuideSectionLabel(
          left: 'Steps in xDrip+ and WatchDrip',
          right: 'watch path',
        ),
        StatusProbeSetupStepCard(
          number: 1,
          title: 'Open xDrip+ Settings',
          body: 'Use the phone where xDrip+ has the latest glucose readings.',
          pathLabel: 'Open',
          pathValue: 'xDrip+ -> Settings',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 2,
          title: 'Find the service/API setting used by watch apps',
          body:
              'Look under Inter-app settings, Web service API, or the watch integration area depending on your xDrip+ version.',
          pathLabel: 'Find',
          pathValue:
              'Settings -> Inter-app settings / Web service API / Watch integration',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 3,
          title: 'Enable the required service',
          body:
              'Turn on the service/API path used by WatchDrip or your watch display app.',
          pathLabel: 'Turn on',
          pathValue: 'Enable the service or API path used by your watch app',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 4,
          title: 'Open WatchDrip',
          body:
              'Confirm WatchDrip is using xDrip+ as the source and refresh the watch display.',
          pathLabel: 'Confirm source',
          pathValue: 'WatchDrip -> source / connection -> xDrip+',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 5,
          title: 'Run the checklist again',
          body:
              'Return to Solgo Insight and check whether the watch path is now detected.',
        ),
        SizedBox(height: 12),
        StatusProbeGuideNote(
          title: 'If you do not use a watch display',
          body:
              'You can ignore this page. A disabled watch path does not mean xDrip+ or Nightscout is broken.',
          icon: Icons.visibility_off_rounded,
        ),
      ],
    );
  }
}
