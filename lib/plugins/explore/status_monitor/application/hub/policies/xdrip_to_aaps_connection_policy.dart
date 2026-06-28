import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/status_level.dart';
import '../metrics/xdrip_aaps_metric_builder.dart';
import 'status_hub_connection_policy.dart';
import 'status_hub_connection_policy_utils.dart';

class XdripToAapsConnectionPolicy implements StatusHubConnectionPolicy {
  final StatusHubConnectionPolicyUtils utils;
  final XdripAapsMetricBuilder metricBuilder;

  const XdripToAapsConnectionPolicy({
    this.utils = const StatusHubConnectionPolicyUtils(),
    this.metricBuilder = const XdripAapsMetricBuilder(),
  });

  @override
  StatusHubConnection evaluate(StatusHubFactBundle facts) {
    final source = facts.xdrip.component;
    final target = facts.aaps.component;
    final state = _state(facts);
    const policyId = 'xdrip_to_aaps_connection_policy';
    final delay = utils.delay(source, target);
    final confidence = _confidence(facts);
    return StatusHubConnection(
      id: StatusHubConnectionId.xdripToAaps,
      from: StatusHubNodeId.xdrip,
      to: StatusHubNodeId.aaps,
      kind: StatusHubConnectionKind.xdripToAaps,
      state: state,
      sourceAge: source.age,
      targetAge: target.age,
      delayVsSource: delay,
      confidence: confidence,
      isPrimaryPath: true,
      chipLabel: facts.aaps.xdripBgSourceObserved
          ? utils.delayLabel(delay)
          : 'BG source?',
      stateSource: const StatusHubSourceRef.derivedPolicy(policyId),
      metrics: metricBuilder.build(facts),
      evidence: [
        ...utils.evidence(source, target),
        StatusHubEvidenceRef(
          id: 'aaps_xdrip_bg_source',
          label: 'BG source',
          valueLabel: facts.aaps.xdripBgSourceObserved
              ? facts.aaps.xdripBgSourceLabel
              : 'not observed',
          level: facts.aaps.xdripBgSourceObserved
              ? facts.aaps.xdripBgSourceLevel
              : StatusLevel.watch,
          source: const StatusHubSourceRef.probeEvidence(
            probeId: 'aaps.bg_source.xdrip_evidence',
            path: 'xdripBgSource',
          ),
        ),
      ],
      userSummary: state == StatusHubState.fresh
          ? 'AAPS sees the xDrip+ BG source path.'
          : 'AAPS evidence is limited. Confirm BG source is xDrip+.',
      nextCheck:
          'In AAPS, verify BG source is xDrip+. xDrip+ Web Server is optional and not part of this score.',
      traceChain: source.traceChain.merge(target.traceChain),
    );
  }

  StatusHubState _state(StatusHubFactBundle facts) {
    final xdrip = facts.xdrip.component.state;
    final aaps = facts.aaps.component.state;
    final bgSourceObserved = facts.aaps.xdripBgSourceObserved;
    if (aaps == StatusHubState.unavailable) {
      return StatusHubState.unavailable;
    }
    if (!bgSourceObserved && utils.freshish(xdrip)) {
      return StatusHubState.limited;
    }
    if (bgSourceObserved && utils.freshish(xdrip) && utils.freshish(aaps)) {
      return StatusHubState.fresh;
    }
    if (utils.freshish(xdrip) && !utils.freshish(aaps)) {
      return StatusHubState.delayed;
    }
    if (xdrip == StatusHubState.stale) {
      return StatusHubState.limited;
    }
    return aaps == StatusHubState.unknown ? StatusHubState.limited : aaps;
  }

  double _confidence(StatusHubFactBundle facts) {
    final base = utils.confidence(facts.xdrip.component, facts.aaps.component);
    if (facts.aaps.xdripBgSourceObserved) {
      return (base + .18).clamp(0, 1);
    }
    return (base * .70).clamp(0, 1);
  }
}
