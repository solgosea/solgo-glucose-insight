import 'package:flutter/material.dart';

import '../widgets/guide/status_probe_guide_components.dart';

class AapsDownstreamChecksPage extends StatelessWidget {
  const AapsDownstreamChecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusProbeGuideShell(
      eyebrow: 'AAPS',
      title: 'AAPS glucose check',
      subtitle: 'When AAPS reports missing glucose data',
      heroTitle: 'AAPS says glucose is missing?',
      heroBody:
          'First confirm xDrip+ is fresh. If xDrip+ has fresh readings, check the AAPS BG source and logs next.',
      icon: Icons.account_tree_rounded,
      children: [
        StatusProbeGuideSectionLabel(
          left: 'Solgo can check',
          right: 'run from checklist',
        ),
        StatusProbeCheckListCard(
          items: [
            StatusProbeCheckItem(
              title: 'AAPS package visibility',
              body:
                  'Checks whether an AAPS package can be found on this phone.',
              stateLabel: 'Auto',
              tone: 'healthy',
              code: 'PKG',
            ),
            StatusProbeCheckItem(
              title: 'AAPS glucose source evidence',
              body:
                  'Looks for evidence that AAPS is using xDrip+ as BG source.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'SRC',
            ),
            StatusProbeCheckItem(
              title: 'AAPS device status evidence',
              body: 'Looks for safe observable device status context.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'DEV',
            ),
            StatusProbeCheckItem(
              title: 'Loop context evidence',
              body:
                  'Shows whether limited context is visible. It does not judge loop decisions.',
              stateLabel: 'Auto',
              tone: 'watch',
              code: 'CTX',
            ),
          ],
        ),
        StatusProbeGuideSectionLabel(
          left: 'What to check in AAPS',
          right: 'user steps',
        ),
        StatusProbeSetupStepCard(
          number: 1,
          title: 'Confirm xDrip+ has fresh data',
          body:
              'If xDrip+ is stale, fix xDrip+ or the collector path first. AAPS may be missing glucose because xDrip+ itself is stale.',
          pathLabel: 'Check first',
          pathValue: 'Solgo Insight -> Status Monitor -> xDrip+',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 2,
          title: 'Open AAPS logs or status',
          body:
              'Look for messages about missing BG, stale BG, sensor source, or sync errors.',
          pathLabel: 'Open',
          pathValue: 'AAPS -> logs / status -> latest glucose-source message',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 3,
          title: 'Confirm BG source',
          body:
              'Make sure AAPS is set to the glucose source you expect, such as xDrip+ or another configured source.',
          pathLabel: 'Verify',
          pathValue: 'AAPS -> BG source -> xDrip+ or your expected source',
        ),
        SizedBox(height: 8),
        StatusProbeSetupStepCard(
          number: 4,
          title: 'Check Nightscout only if AAPS depends on it',
          body:
              'If AAPS uses local xDrip+ data, stale Nightscout does not automatically mean AAPS is broken.',
        ),
        SizedBox(height: 12),
        StatusProbeGuideNote(
          title: 'Important boundary',
          body:
              'Solgo Insight only observes status. It does not control AAPS, change loop settings, acknowledge alarms, send bolus commands, or provide therapy advice.',
          icon: Icons.shield_rounded,
        ),
      ],
    );
  }
}
