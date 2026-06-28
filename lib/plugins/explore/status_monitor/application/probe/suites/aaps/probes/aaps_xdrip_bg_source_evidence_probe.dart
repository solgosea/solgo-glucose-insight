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

class AapsXdripBgSourceEvidenceProbe implements StatusProbeDriver {
  final AapsProbePlatformSource source;

  AapsXdripBgSourceEvidenceProbe({
    this.source = const AapsProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('aaps.bg_source.xdrip_evidence'),
    suiteId: 'aaps',
    label: 'AAPS xDrip BG source evidence',
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
    if (!snapshot.receiverConfigured || !snapshot.evidenceObserved) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.notObserved,
        observedAt: context.now,
        summary: 'No AAPS downstream evidence has been observed.',
        confidence: 0,
        signals: [
          signal(
            'Receiver',
            snapshot.receiverConfigured ? 'configured' : 'not configured',
          ),
        ],
        sourceRefs: [sourceRef('android', 'com.metaguru.probe.AAPS_CONTEXT')],
      );
    }
    final bgSource = snapshot.bgSource?.toLowerCase().trim();
    final usesXdrip = bgSource == 'xdrip' || bgSource == 'xdrip+';
    if (!usesXdrip) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.watch,
        observedAt: snapshot.latestEvidenceAt ?? context.now,
        summary: 'AAPS evidence was observed, but BG source is not xDrip+.',
        confidence: 0.5,
        signals: [signal('BG source', snapshot.bgSource ?? 'unknown')],
        evidence: [
          evidence(
            'Latest AAPS evidence',
            'observed',
            observedAt: snapshot.latestEvidenceAt,
          ),
        ],
        sourceRefs: [sourceRef('android', 'aaps.bgSource')],
      );
    }
    return probeResult(
      definition: definition,
      state: StatusProbeState.healthy,
      observedAt: snapshot.latestEvidenceAt ?? context.now,
      summary: 'AAPS downstream evidence reports xDrip+ as BG source.',
      confidence: 1,
      signals: [signal('BG source', snapshot.bgSource ?? 'xDrip+')],
      evidence: [
        evidence(
          'Latest AAPS evidence',
          'observed',
          observedAt: snapshot.latestEvidenceAt,
        ),
      ],
      sourceRefs: [sourceRef('android', 'aaps.bgSource')],
    );
  }
}
