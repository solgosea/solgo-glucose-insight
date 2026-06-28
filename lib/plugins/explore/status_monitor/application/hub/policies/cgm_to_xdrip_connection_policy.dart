import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../metrics/cgm_xdrip_metric_builder.dart';
import 'status_hub_connection_policy.dart';
import 'status_hub_connection_policy_utils.dart';

class CgmToXdripConnectionPolicy implements StatusHubConnectionPolicy {
  final StatusHubConnectionPolicyUtils utils;
  final CgmXdripMetricBuilder metricBuilder;

  const CgmToXdripConnectionPolicy({
    this.utils = const StatusHubConnectionPolicyUtils(),
    this.metricBuilder = const CgmXdripMetricBuilder(),
  });

  @override
  StatusHubConnection evaluate(StatusHubFactBundle facts) {
    final source = facts.cgm.component;
    final target = facts.xdrip.component;
    final delay = utils.delay(source, target);
    final state = _state(source.state, target.state);
    const policyId = 'cgm_to_xdrip_connection_policy';
    final confidence = utils.confidence(source, target);
    return StatusHubConnection(
      id: StatusHubConnectionId.cgmToXdrip,
      from: StatusHubNodeId.cgmSensor,
      to: StatusHubNodeId.xdrip,
      kind: StatusHubConnectionKind.cgmToXdrip,
      state: state,
      sourceAge: source.age,
      targetAge: target.age,
      delayVsSource: delay,
      confidence: confidence,
      isPrimaryPath: true,
      chipLabel: utils.delayLabel(delay),
      stateSource: const StatusHubSourceRef.derivedPolicy(policyId),
      metrics: metricBuilder.build(facts),
      evidence: utils.evidence(source, target),
      userSummary: state == StatusHubState.fresh
          ? 'Sensor evidence and xDrip+ local data are aligned.'
          : 'Check the collector, sensor bridge, and xDrip+ latest BG age.',
      nextCheck:
          'Open xDrip+ and compare its latest BG age with the sensor path.',
      traceChain: source.traceChain.merge(target.traceChain),
    );
  }

  StatusHubState _state(StatusHubState cgm, StatusHubState xdrip) {
    if (cgm == StatusHubState.unavailable ||
        xdrip == StatusHubState.unavailable) {
      return StatusHubState.unavailable;
    }
    if (cgm == StatusHubState.stale && xdrip == StatusHubState.stale) {
      return StatusHubState.stale;
    }
    if (cgm == StatusHubState.fresh && xdrip != StatusHubState.fresh) {
      return StatusHubState.delayed;
    }
    if (cgm == StatusHubState.unknown || xdrip == StatusHubState.unknown) {
      return StatusHubState.limited;
    }
    return xdrip;
  }
}
