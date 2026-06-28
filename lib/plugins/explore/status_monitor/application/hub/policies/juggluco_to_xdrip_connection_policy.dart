import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/status_level.dart';
import '../metrics/juggluco_xdrip_metric_builder.dart';
import 'status_hub_connection_policy.dart';
import 'status_hub_connection_policy_utils.dart';

class JugglucoToXdripConnectionPolicy implements StatusHubConnectionPolicy {
  final StatusHubConnectionPolicyUtils utils;
  final JugglucoXdripMetricBuilder metricBuilder;

  const JugglucoToXdripConnectionPolicy({
    this.utils = const StatusHubConnectionPolicyUtils(),
    this.metricBuilder = const JugglucoXdripMetricBuilder(),
  });

  @override
  StatusHubConnection evaluate(StatusHubFactBundle facts) {
    final source = facts.juggluco.component;
    final target = facts.xdrip.component;
    final compatible = facts.juggluco.xdripCompatiblePathObserved;
    final broadcastObserved = _broadcastObserved(facts);
    final state = _state(facts, compatible, broadcastObserved);
    const policyId = 'juggluco_to_xdrip_connection_policy';
    final delay = utils.delay(source, target);
    final confidence = utils.confidence(source, target);
    return StatusHubConnection(
      id: StatusHubConnectionId.jugglucoToXdrip,
      from: StatusHubNodeId.juggluco,
      to: StatusHubNodeId.xdrip,
      kind: StatusHubConnectionKind.jugglucoToXdrip,
      state: state,
      sourceAge: source.age,
      targetAge: target.age,
      delayVsSource: delay,
      confidence: confidence,
      isPrimaryPath: compatible,
      chipLabel: compatible ? utils.delayLabel(delay) : 'setup',
      stateSource: const StatusHubSourceRef.derivedPolicy(policyId),
      metrics: metricBuilder.build(facts),
      evidence: [
        ...utils.evidence(source, target),
        StatusHubEvidenceRef(
          id: 'juggluco_xdrip_path',
          label: 'xDrip+ path',
          valueLabel:
              compatible && broadcastObserved ? 'observed' : 'not observed',
          level: compatible && broadcastObserved
              ? StatusLevel.healthy
              : StatusLevel.watch,
          source: const StatusHubSourceRef.probeEvidence(
            probeId: 'juggluco.broadcast.xdrip_compatible',
            path: 'xdripCompatiblePathObserved',
          ),
        ),
      ],
      userSummary: state == StatusHubState.fresh
          ? 'Juggluco broadcasts are visible through the xDrip+ path.'
          : compatible && !broadcastObserved
              ? 'The xDrip-compatible path is configured; wait for a recent broadcast.'
              : 'Verify Juggluco broadcasts to xDrip+ and xDrip+ is receiving it.',
      nextCheck:
          'In Juggluco, select the xDrip+ package; then confirm xDrip+ shows fresh local BG.',
      traceChain: source.traceChain.merge(target.traceChain),
    );
  }

  StatusHubState _state(
    StatusHubFactBundle facts,
    bool compatible,
    bool broadcastObserved,
  ) {
    final juggluco = facts.juggluco.component.state;
    final xdrip = facts.xdrip.component.state;
    if (compatible && !broadcastObserved) {
      return StatusHubState.limited;
    }
    if (compatible && facts.juggluco.component.age == null) {
      return StatusHubState.limited;
    }
    if (!compatible && juggluco == StatusHubState.fresh) {
      return StatusHubState.limited;
    }
    if (compatible &&
        broadcastObserved &&
        juggluco == StatusHubState.fresh &&
        xdrip != StatusHubState.fresh) {
      return StatusHubState.delayed;
    }
    if (compatible &&
        broadcastObserved &&
        juggluco == StatusHubState.fresh &&
        xdrip == StatusHubState.fresh) {
      return StatusHubState.fresh;
    }
    if (compatible && broadcastObserved && utils.freshish(xdrip)) {
      return StatusHubState.delayed;
    }
    if (juggluco == StatusHubState.unavailable) {
      return StatusHubState.unavailable;
    }
    return xdrip == StatusHubState.unknown ? StatusHubState.limited : xdrip;
  }

  bool _broadcastObserved(StatusHubFactBundle facts) {
    final observedPath = facts.juggluco.observedPathLabel.trim().toLowerCase();
    if (observedPath.isEmpty ||
        observedPath.contains('no broadcast') ||
        observedPath.contains('not seen') ||
        observedPath.contains('waiting')) {
      return false;
    }
    var hasBroadcastFreshnessEvidence = false;
    for (final evidence in facts.juggluco.component.evidence) {
      final id = evidence.id.toLowerCase();
      final label = evidence.label.toLowerCase();
      if (id.contains('juggluco_broadcast') || label.contains('broadcast')) {
        hasBroadcastFreshnessEvidence = true;
        final value = evidence.valueLabel.trim().toLowerCase();
        if (value.contains('waiting') ||
            value.contains('no broadcast') ||
            value.contains('not seen') ||
            value.contains('unknown')) {
          return false;
        }
      }
    }
    return hasBroadcastFreshnessEvidence;
  }
}
