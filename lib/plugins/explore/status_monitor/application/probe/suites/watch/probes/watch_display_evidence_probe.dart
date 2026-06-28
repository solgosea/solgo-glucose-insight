import '../../../../../data/probe/platform/watch_probe_platform_source.dart';
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

class WatchDisplayEvidenceProbe implements StatusProbeDriver {
  final WatchProbePlatformSource source;

  WatchDisplayEvidenceProbe({
    this.source = const WatchProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('watch.display.evidence'),
    suiteId: 'watch',
    label: 'Watch display evidence',
    kind: StatusProbeKind.watch,
    category: StatusProbeCategory.optional,
    runMode: StatusProbeRunMode.derived,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    if (!source.isSupported) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.unknown,
        observedAt: context.now,
        summary: 'Watch evidence probe is only supported on Android.',
        confidence: 0,
        sourceRefs: [sourceRef('android', 'watch_evidence_bridge')],
      );
    }
    final snapshot = await source.latestEvidence();
    if (!snapshot.receiverConfigured || !snapshot.evidenceObserved) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: context.now,
        summary: 'No watch display evidence has been observed.',
        confidence: 0,
        sourceRefs: [
          sourceRef('android', 'com.metaguru.probe.WATCHDRIP_DISPLAY'),
        ],
      );
    }
    if (!snapshot.displayObserved) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: snapshot.latestEvidenceAt ?? context.now,
        summary: 'Watch bridge evidence was observed without display data.',
        confidence: 0.35,
        signals: [signal('Display', 'not observed')],
        sourceRefs: [sourceRef('android', 'watch.displayObserved')],
      );
    }
    return probeResult(
      definition: definition,
      state: StatusProbeState.healthy,
      observedAt: snapshot.latestEvidenceAt ?? context.now,
      summary: 'Watch display evidence was observed.',
      confidence: 0.8,
      signals: [
        signal('Bridge', snapshot.bridgeName ?? 'watch'),
        signal('Display', 'observed'),
      ],
      evidence: [
        evidence(
          'Latest watch evidence',
          'observed',
          observedAt: snapshot.latestEvidenceAt,
        ),
      ],
      sourceRefs: [sourceRef('android', 'watch.displayObserved')],
    );
  }
}
