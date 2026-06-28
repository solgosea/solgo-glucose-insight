import '../../../../../data/probe/platform/juggluco_probe_platform_source.dart';
import '../../../../../domain/juggluco/juggluco_broadcast_format.dart';
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

class JugglucoXdripCompatibleBroadcastProbe implements StatusProbeDriver {
  final JugglucoProbePlatformSource source;

  JugglucoXdripCompatibleBroadcastProbe({
    this.source = const JugglucoProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('juggluco.broadcast.xdrip_compatible'),
    suiteId: 'juggluco',
    label: 'Juggluco xDrip-compatible broadcast',
    kind: StatusProbeKind.juggluco,
    category: StatusProbeCategory.broadcast,
    runMode: StatusProbeRunMode.passive,
    requiredForCorePath: true,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    final snapshot = await source.latestBroadcast();
    final compatible = snapshot.latestByPath
        .where((item) =>
            item.format == JugglucoBroadcastFormat.xdripCompatible ||
            item.path == JugglucoBroadcastPath.xdripLocal ||
            item.path.isXdripCompatible)
        .toList(growable: false);
    final latest = compatible.isEmpty ? null : compatible.first;
    if (latest == null) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: context.now,
        summary: 'No xDrip-compatible Juggluco broadcast has been observed.',
        confidence: 0,
        sourceRefs: [
          sourceRef('android', 'com.eveningoutpost.dexdrip.BgEstimate'),
        ],
      );
    }
    return probeResult(
      definition: definition,
      state: StatusProbeState.healthy,
      observedAt: latest.at ?? context.now,
      summary: 'Juggluco xDrip-compatible broadcast observed.',
      confidence: 1,
      signals: [signal('Path', latest.path.label)],
      evidence: [
        evidence('Format', latest.format.label, observedAt: latest.at),
      ],
      sourceRefs: [
        sourceRef('android', 'com.eveningoutpost.dexdrip.BgEstimate'),
      ],
    );
  }
}
