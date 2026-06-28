import '../../../../../domain/probe/status_probe_category.dart';
import '../../../../../domain/probe/status_probe_context.dart';
import '../../../../../domain/probe/status_probe_definition.dart';
import '../../../../../domain/probe/status_probe_id.dart';
import '../../../../../domain/probe/status_probe_kind.dart';
import '../../../../../domain/probe/status_probe_result.dart';
import '../../../../../domain/probe/status_probe_run_mode.dart';
import '../../../../../domain/probe/status_probe_state.dart';
import '../../../contracts/status_probe_driver.dart';
import '../../status_probe_result_helpers.dart';

class NightscoutStatusReachableProbe implements StatusProbeDriver {
  final StatusProbeClientFactory clientFactory;

  const NightscoutStatusReachableProbe({
    this.clientFactory = nightscoutClientFrom,
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('nightscout.status.reachable'),
    suiteId: 'nightscout',
    label: 'Nightscout status endpoint',
    kind: StatusProbeKind.nightscout,
    category: StatusProbeCategory.api,
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
        summary: 'Nightscout is not configured.',
      );
    }
    final result = await client.get('/api/v1/status.json');
    return probeResult(
      definition: definition,
      state:
          result.reachable ? StatusProbeState.healthy : StatusProbeState.issue,
      observedAt: context.now,
      summary: result.reachable
          ? 'Nightscout status endpoint is reachable.'
          : 'Nightscout status endpoint is not reachable.',
      confidence: result.reachable ? 1 : 0.1,
      elapsed: result.elapsed,
      signals: [signal('HTTP', result.statusCode?.toString() ?? 'no response')],
      sourceRefs: [sourceRef('nightscout-api', '/api/v1/status.json')],
    );
  }
}
