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

class WatchXdripWebServiceEntriesProbe implements StatusProbeDriver {
  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('watch.xdrip_web_service.entries'),
    suiteId: 'watch',
    label: 'xDrip+ Web Service entries',
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
        summary:
            'xDrip+ Web Service entries are not configured for watch display.',
      );
    }
    final entries = await client.loadEntries24h(context.now);
    final hasEntries = entries.isNotEmpty;
    return probeResult(
      definition: definition,
      state: hasEntries ? StatusProbeState.healthy : StatusProbeState.waiting,
      observedAt: context.now,
      summary: hasEntries
          ? 'xDrip+ Web Service returned ${entries.length} entries for watch display.'
          : 'xDrip+ Web Service returned no entries for watch display.',
      confidence: hasEntries ? 1 : 0.3,
      signals: [signal('Entries', entries.length.toString())],
      sourceRefs: [sourceRef('xdrip-web-service', '/sgv.json', 'watch')],
    );
  }
}
