import 'package:flutter/material.dart';

import '../widgets/guide/status_probe_guide_components.dart';

class JugglucoProbeGuidePage extends StatelessWidget {
  const JugglucoProbeGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusProbeGuideShell(
      eyebrow: 'Juggluco',
      title: 'Juggluco setup',
      subtitle: 'Libre / Juggluco upstream evidence',
      heroTitle: 'Check the path before xDrip+',
      heroBody:
          'For Juggluco users, broadcast evidence can show whether data exists upstream before it reaches xDrip+ or Nightscout.',
      icon: Icons.broadcast_on_personal_rounded,
      children: [
        StatusProbeGuideSectionLabel(
          left: 'Solgo can check',
          right: 'run from checklist',
        ),
        StatusProbeCheckListCard(
          items: [
            StatusProbeCheckItem(
              title: 'Juggluco package visibility',
              body: 'Checks whether Juggluco can be found on this phone.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'PKG',
            ),
            StatusProbeCheckItem(
              title: 'Glucodata broadcast',
              body: 'Looks for Juggluco native glucodata minute payloads.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'BG',
            ),
            StatusProbeCheckItem(
              title: 'xDrip-compatible broadcast',
              body: 'Looks for the compatible BgEstimate style payload.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'XD',
            ),
            StatusProbeCheckItem(
              title: 'Broadcast freshness',
              body: 'Checks whether the latest Juggluco evidence is recent.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'AGE',
            ),
          ],
        ),
        StatusProbeGuideSectionLabel(
          left: 'Steps in Juggluco',
          right: 'receiver list',
        ),
        StatusProbeSetupStepCard(
          number: 1,
          title: 'Open Juggluco Settings',
          body: 'Use the phone where Juggluco receives Libre data.',
          pathLabel: 'Open',
          pathValue: 'Juggluco -> Settings',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 2,
          title: 'Find broadcast options',
          body:
              'Look for xDrip broadcast or Glucodata broadcast, depending on your current data path.',
          pathLabel: 'Find',
          pathValue: 'Settings -> xDrip broadcast / Glucodata broadcast',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 3,
          title: 'Select Solgo Insight as receiver',
          body:
              'Juggluco scans apps listening to the broadcast action. Solgo Insight should appear once installed.',
          pathLabel: 'Select receiver',
          pathValue: 'Choose Solgo Insight or paste the package if required',
          code: 'com.metaguru.smartxdrip',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 4,
          title: 'Save and wait for new data',
          body:
              'Return to Solgo Insight and run the checklist after the next Libre / Juggluco update.',
        ),
        SizedBox(height: 12),
        StatusProbeGuideNote(
          title: 'Ready to monitor',
          body:
              'Juggluco evidence is useful when Libre data reaches xDrip+ through Juggluco. It helps the hub show whether the issue may be before xDrip+.',
          icon: Icons.route_rounded,
        ),
      ],
    );
  }
}
