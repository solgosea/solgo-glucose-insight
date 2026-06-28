import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../metrics/xdrip_nightscout_metric_builder.dart';
import 'status_hub_connection_policy.dart';
import 'status_hub_connection_policy_utils.dart';

class XdripToNightscoutConnectionPolicy implements StatusHubConnectionPolicy {
  final StatusHubConnectionPolicyUtils utils;
  final XdripNightscoutMetricBuilder metricBuilder;

  const XdripToNightscoutConnectionPolicy({
    this.utils = const StatusHubConnectionPolicyUtils(),
    this.metricBuilder = const XdripNightscoutMetricBuilder(),
  });

  @override
  StatusHubConnection evaluate(StatusHubFactBundle facts) {
    final source = facts.xdrip.component;
    final target = facts.nightscout.component;
    final state = utils.freshnessConnectionState(source, target);
    const policyId = 'xdrip_to_nightscout_connection_policy';
    final delay = utils.delay(source, target);
    final confidence = utils.confidence(source, target);
    return StatusHubConnection(
      id: StatusHubConnectionId.xdripToNightscout,
      from: StatusHubNodeId.xdrip,
      to: StatusHubNodeId.nightscout,
      kind: StatusHubConnectionKind.xdripToNightscout,
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
          ? 'xDrip+ and Nightscout freshness are aligned.'
          : 'xDrip+ looks newer than Nightscout. Check cloud upload.',
      nextCheck:
          'Review xDrip+ cloud upload, Nightscout entries, and token/network status.',
      traceChain: source.traceChain.merge(target.traceChain),
    );
  }
}
