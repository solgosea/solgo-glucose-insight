import '../../../../../data/probe/platform/juggluco_probe_platform_source.dart';
import '../../../../../domain/juggluco/juggluco_broadcast_path.dart';
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

class JugglucoGlucodataBroadcastProbe implements StatusProbeDriver {
  final JugglucoProbePlatformSource source;

  JugglucoGlucodataBroadcastProbe({
    this.source = const JugglucoProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('juggluco.broadcast.glucodata_minute'),
    suiteId: 'juggluco',
    label: 'Juggluco glucodata broadcast',
    kind: StatusProbeKind.juggluco,
    category: StatusProbeCategory.broadcast,
    runMode: StatusProbeRunMode.passive,
    requiredForCorePath: true,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    final snapshot = await source.latestBroadcast();
    final direct = snapshot.latestByPath
        .where((item) => item.path == JugglucoBroadcastPath.glucodata)
        .toList(growable: false);
    final latest = direct.isEmpty ? null : direct.first;
    if (latest == null) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: context.now,
        summary: 'No glucodata.Minute broadcast has been observed.',
        confidence: 0,
        sourceRefs: [sourceRef('android', 'glucodata.Minute')],
      );
    }
    return probeResult(
      definition: definition,
      state: StatusProbeState.healthy,
      observedAt: latest.at ?? context.now,
      summary: 'Juggluco glucodata.Minute broadcast observed.',
      confidence: 1,
      signals: [
        if (latest.glucose != null)
          signal('Glucose', '${latest.glucose} ${latest.unit ?? ''}'.trim()),
      ],
      evidence: [
        evidence('Path', latest.path.label, observedAt: latest.at),
      ],
      sourceRefs: [sourceRef('android', 'glucodata.Minute')],
    );
  }
}
