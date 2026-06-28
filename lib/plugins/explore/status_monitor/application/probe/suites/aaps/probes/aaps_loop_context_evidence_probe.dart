import '../../../../../data/probe/platform/aaps_probe_platform_source.dart';
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

class AapsLoopContextEvidenceProbe implements StatusProbeDriver {
  final AapsProbePlatformSource source;

  AapsLoopContextEvidenceProbe({
    this.source = const AapsProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('aaps.loop.context_evidence'),
    suiteId: 'aaps',
    label: 'AAPS loop context evidence',
    kind: StatusProbeKind.aaps,
    category: StatusProbeCategory.downstream,
    runMode: StatusProbeRunMode.derived,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    if (!source.isSupported) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.unknown,
        observedAt: context.now,
        summary: 'AAPS evidence probe is only supported on Android.',
        confidence: 0,
        sourceRefs: [sourceRef('android', 'aaps_evidence_bridge')],
      );
    }
    final snapshot = await source.latestEvidence();
    if (!snapshot.evidenceObserved) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: context.now,
        summary: 'No AAPS loop context evidence has been observed.',
        confidence: 0,
        sourceRefs: [sourceRef('android', 'com.metaguru.probe.AAPS_CONTEXT')],
      );
    }
    if (!snapshot.loopContextObserved) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: snapshot.latestEvidenceAt ?? context.now,
        summary: 'AAPS context was observed without loop context fields.',
        confidence: 0.35,
        signals: [signal('Loop context', 'not observed')],
        sourceRefs: [sourceRef('android', 'aaps.loopContextObserved')],
      );
    }
    return probeResult(
      definition: definition,
      state: StatusProbeState.healthy,
      observedAt: snapshot.latestEvidenceAt ?? context.now,
      summary: 'AAPS loop context evidence was observed.',
      confidence: 0.8,
      signals: [
        signal('Loop context', 'observed'),
        if (snapshot.loopState != null)
          signal('Loop state', snapshot.loopState!),
      ],
      evidence: [
        evidence(
          'Latest loop context evidence',
          'observed',
          observedAt: snapshot.latestEvidenceAt,
        ),
      ],
      sourceRefs: [sourceRef('android', 'aaps.loopContextObserved')],
    );
  }
}
