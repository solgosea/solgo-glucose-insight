import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/evidence/status_evidence_source_kind.dart';
import '../../../domain/status_level.dart';
import '../../../domain/xdrip/xdrip_broadcast_state.dart';
import '../../../domain/xdrip/xdrip_pipeline_gate_result.dart';
import '../../../domain/xdrip/xdrip_reading_source_state.dart';

class XdripPipelineGatePolicy {
  const XdripPipelineGatePolicy();

  XdripPipelineGateResult evaluate(StatusAnalysisContext context) {
    final xdrip = context.evidence.xdripLocalEvidence;
    final broadcast = context.evidence.xdripBroadcastEvidence;
    final readings = context.evidence.selection.xdripLiveReadings;
    final hasLocalService = xdrip.serviceProbe?.reachable == true;
    final hasFreshBroadcast =
        broadcast.state(context.now) == XdripBroadcastState.fresh;
    final hasLiveReadings = readings.readings.isNotEmpty;
    final sourceState = switch (readings.sourceKind) {
      StatusEvidenceSourceKind.xdripLocal => XdripReadingSourceState.xdripLocal,
      StatusEvidenceSourceKind.nightscout =>
        XdripReadingSourceState.nightscoutFallback,
      _ => XdripReadingSourceState.none,
    };

    if (hasLocalService && !hasLiveReadings) {
      return const XdripPipelineGateResult(
        hasLocalService: true,
        hasLiveReadings: false,
        readingSourceState: XdripReadingSourceState.none,
        maxScore: 45,
        maxLevel: StatusLevel.watch,
        message:
            'xDrip+ Local is reachable, but no live glucose readings are visible.',
      );
    }

    if (hasLocalService &&
        sourceState == XdripReadingSourceState.nightscoutFallback) {
      return const XdripPipelineGateResult(
        hasLocalService: true,
        hasLiveReadings: true,
        readingSourceState: XdripReadingSourceState.nightscoutFallback,
        maxScore: 85,
        maxLevel: StatusLevel.watch,
        message:
            'xDrip+ Local is reachable; readings are currently observed through Nightscout.',
      );
    }

    if (!hasLocalService && hasLiveReadings && !hasFreshBroadcast) {
      return XdripPipelineGateResult(
        hasLocalService: false,
        hasLiveReadings: true,
        readingSourceState: sourceState,
        maxScore: 75,
        maxLevel: StatusLevel.watch,
        message:
            'Live readings are visible, but the xDrip+ Local service is not reachable.',
      );
    }

    if (!hasLocalService && !hasLiveReadings && !hasFreshBroadcast) {
      return const XdripPipelineGateResult(
        hasLocalService: false,
        hasLiveReadings: false,
        readingSourceState: XdripReadingSourceState.none,
        maxScore: 0,
        message:
            'No xDrip+ service, local broadcast, or live glucose readings are visible.',
      );
    }

    return XdripPipelineGateResult(
      hasLocalService: hasLocalService,
      hasLiveReadings: hasLiveReadings,
      readingSourceState: sourceState == XdripReadingSourceState.none
          ? XdripReadingSourceState.xdripLocal
          : sourceState,
      message: 'xDrip+ readings and local broadcast path are visible.',
    );
  }
}
