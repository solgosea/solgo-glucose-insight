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

class NightscoutDevicestatusProbe implements StatusProbeDriver {
  final StatusProbeClientFactory clientFactory;

  const NightscoutDevicestatusProbe({
    this.clientFactory = nightscoutClientFrom,
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('nightscout.devicestatus.visible'),
    suiteId: 'nightscout',
    label: 'Nightscout devicestatus',
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
        summary: 'Nightscout devicestatus is not configured.',
      );
    }
    final result = await client.get(
      '/api/v1/devicestatus.json',
      queryParameters: {'count': 10},
    );
    final rows = result.data is List ? result.data as List : const [];
    final hasRows = result.reachable && rows.isNotEmpty;
    return probeResult(
      definition: definition,
      state: hasRows ? StatusProbeState.healthy : StatusProbeState.unknown,
      observedAt: context.now,
      summary: hasRows
          ? 'Nightscout devicestatus returned ${rows.length} records.'
          : 'Nightscout devicestatus has no recent visible records.',
      confidence: hasRows ? 0.8 : 0.2,
      elapsed: result.elapsed,
      signals: [signal('Rows', rows.length.toString())],
      sourceRefs: [sourceRef('nightscout-api', '/api/v1/devicestatus.json')],
    );
  }
}
