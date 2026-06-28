import '../../../../../domain/probe/status_probe_category.dart';
import '../../../../../domain/probe/status_probe_context.dart';
import '../../../../../domain/probe/status_probe_definition.dart';
import '../../../../../domain/probe/status_probe_id.dart';
import '../../../../../domain/probe/status_probe_kind.dart';
import '../../../../../domain/probe/status_probe_result.dart';
import '../../../../../domain/probe/status_probe_run_mode.dart';
import '../../../../../domain/probe/status_probe_state.dart';
import '../../../contracts/status_probe_driver.dart';
import '../../../policies/status_probe_freshness_policy.dart';
import '../../status_probe_result_helpers.dart';

class NightscoutEntriesFreshnessProbe implements StatusProbeDriver {
  final StatusProbeFreshnessPolicy freshnessPolicy;
  final StatusProbeClientFactory clientFactory;

  const NightscoutEntriesFreshnessProbe({
    this.freshnessPolicy = const StatusProbeFreshnessPolicy(),
    this.clientFactory = nightscoutClientFrom,
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('nightscout.entries.freshness'),
    suiteId: 'nightscout',
    label: 'Nightscout entries freshness',
    kind: StatusProbeKind.nightscout,
    category: StatusProbeCategory.freshness,
    runMode: StatusProbeRunMode.active,
    requiredForCorePath: true,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    final client = clientFactory(context.target);
    if (client == null) {
      return notConfigured(
        definition: definition,
        observedAt: context.now,
        summary: 'Nightscout entries are not configured.',
      );
    }
    final entries = await client.loadEntries24h(context.now);
    final latest = entries.isEmpty
        ? null
        : entries
            .map((entry) => entry.timestamp)
            .reduce((a, b) => a.isAfter(b) ? a : b);
    final state = freshnessPolicy.state(latest, context.now);
    return probeResult(
      definition: definition,
      state: entries.isEmpty ? StatusProbeState.waiting : state,
      observedAt: latest ?? context.now,
      summary: entries.isEmpty
          ? 'Nightscout returned no recent entries.'
          : 'Latest Nightscout entry age is ${context.now.difference(latest!).inMinutes}m.',
      confidence: entries.isEmpty
          ? 0.2
          : freshnessPolicy.confidence(latest, context.now),
      signals: [
        signal('Entries', entries.length.toString()),
        signal(
          'Age',
          latest == null
              ? 'not observed'
              : '${context.now.difference(latest).inMinutes}m',
        ),
      ],
      sourceRefs: [sourceRef('nightscout-api', '/api/v1/entries.json')],
    );
  }
}
