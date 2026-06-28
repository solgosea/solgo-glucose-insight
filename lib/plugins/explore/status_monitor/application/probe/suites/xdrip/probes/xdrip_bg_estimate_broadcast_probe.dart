import '../../../../../data/probe/platform/xdrip_probe_platform_source.dart';
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

class XdripBgEstimateBroadcastProbe implements StatusProbeDriver {
  final XdripProbePlatformSource source;

  XdripBgEstimateBroadcastProbe({
    this.source = const XdripProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('xdrip.broadcast.bg_estimate'),
    suiteId: 'xdrip',
    label: 'xDrip+ BG broadcast',
    kind: StatusProbeKind.xdrip,
    category: StatusProbeCategory.broadcast,
    runMode: StatusProbeRunMode.passive,
    requiredForCorePath: true,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    if (!source.isSupported) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.unknown,
        observedAt: context.now,
        summary: 'Broadcast probe is only supported on Android.',
        confidence: 0,
        sourceRefs: [sourceRef('android', 'xdrip_broadcast_bridge')],
      );
    }
    final snapshot = await source.latestBroadcast();
    if (!snapshot.receiverConfigured || !snapshot.broadcastObserved) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: context.now,
        summary: 'No xDrip+ BgEstimate broadcast has been observed.',
        confidence: 0,
        signals: [
          signal('Receiver',
              snapshot.receiverConfigured ? 'configured' : 'not configured'),
        ],
        sourceRefs: [
          sourceRef('android', 'com.eveningoutpost.dexdrip.BgEstimate'),
        ],
      );
    }
    return probeResult(
      definition: definition,
      state: StatusProbeState.healthy,
      observedAt: snapshot.latestBroadcastAt ?? context.now,
      summary: 'xDrip+ BgEstimate broadcast observed.',
      confidence: snapshot.payload.valid ? 1 : 0.75,
      signals: [
        signal('Action', snapshot.payload.sourceAction ?? 'BgEstimate'),
        if (snapshot.payload.glucose != null)
          signal(
              'Glucose',
              '${snapshot.payload.glucose} ${snapshot.payload.unit ?? ''}'
                  .trim()),
      ],
      evidence: [
        evidence(
          'Latest broadcast',
          'observed',
          observedAt: snapshot.latestBroadcastAt,
        ),
      ],
      sourceRefs: [
        sourceRef('android', 'com.eveningoutpost.dexdrip.BgEstimate'),
      ],
    );
  }
}
