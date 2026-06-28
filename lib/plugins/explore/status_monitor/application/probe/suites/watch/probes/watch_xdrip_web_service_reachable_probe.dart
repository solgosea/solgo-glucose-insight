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

class WatchXdripWebServiceReachableProbe implements StatusProbeDriver {
  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('watch.xdrip_web_service.reachable'),
    suiteId: 'watch',
    label: 'xDrip+ Web Service reachable',
    kind: StatusProbeKind.watch,
    category: StatusProbeCategory.api,
    runMode: StatusProbeRunMode.active,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    final client = xdripClientFrom(context.target);
    if (client == null) {
      return notConfigured(
        definition: definition,
        observedAt: context.now,
        summary: 'xDrip+ Web Service is not configured for watch display.',
      );
    }
    final started = DateTime.now();
    final result = await client.checkService();
    return probeResult(
      definition: definition,
      state:
          result.reachable ? StatusProbeState.healthy : StatusProbeState.issue,
      observedAt: context.now,
      summary: result.reachable
          ? 'xDrip+ Web Service is reachable for watch display.'
          : 'xDrip+ Web Service is not reachable for watch display.',
      confidence: result.reachable ? 1 : 0.2,
      elapsed: DateTime.now().difference(started),
      signals: [signal('HTTP', result.statusCode?.toString() ?? 'no response')],
      sourceRefs: [sourceRef('xdrip-web-service', '/status.json', 'watch')],
    );
  }
}
