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

class NightscoutResponseTimeProbe implements StatusProbeDriver {
  final StatusProbeClientFactory clientFactory;

  const NightscoutResponseTimeProbe({
    this.clientFactory = nightscoutClientFrom,
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('nightscout.response_time'),
    suiteId: 'nightscout',
    label: 'Nightscout response time',
    kind: StatusProbeKind.nightscout,
    category: StatusProbeCategory.api,
    runMode: StatusProbeRunMode.active,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    final client = clientFactory(context.target);
    if (client == null) {
      return notConfigured(
        definition: definition,
        observedAt: context.now,
        summary: 'Nightscout response time is not configured.',
      );
    }
    final result = await client.get('/api/v1/status.json');
    final elapsedMs = result.elapsed.inMilliseconds;
    final state = !result.reachable
        ? StatusProbeState.issue
        : elapsedMs > 3000
            ? StatusProbeState.issue
            : elapsedMs > 500
                ? StatusProbeState.watch
                : StatusProbeState.healthy;
    return probeResult(
      definition: definition,
      state: state,
      observedAt: context.now,
      summary: 'Nightscout response time is ${elapsedMs}ms.',
      confidence: result.reachable ? 1 : 0.1,
      elapsed: result.elapsed,
      signals: [signal('Latency', '${elapsedMs}ms')],
      sourceRefs: [sourceRef('nightscout-api', '/api/v1/status.json')],
    );
  }
}
