import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import 'status_hub_connection_policy.dart';
import 'status_hub_connection_policy_utils.dart';

class XdripToWatchConnectionPolicy implements StatusHubConnectionPolicy {
  final StatusHubConnectionPolicyUtils utils;

  const XdripToWatchConnectionPolicy({
    this.utils = const StatusHubConnectionPolicyUtils(),
  });

  @override
  StatusHubConnection evaluate(StatusHubFactBundle facts) {
    final source = facts.xdrip.component;
    final target = facts.watch.component;
    final delay = utils.delay(source, target);
    final confidence = utils.confidence(source, target);
    final state = _state(facts);
    return StatusHubConnection(
      id: StatusHubConnectionId.xdripToWatch,
      from: StatusHubNodeId.xdrip,
      to: StatusHubNodeId.watch,
      kind: StatusHubConnectionKind.xdripToWatch,
      state: state,
      sourceAge: source.age,
      targetAge: target.age,
      delayVsSource: delay,
      confidence: confidence,
      isPrimaryPath: false,
      chipLabel: facts.watch.webServiceReachable
          ? utils.delayLabel(delay)
          : 'web service',
      showInDetails: facts.watch.bridgePackageObserved,
      stateSource: const StatusHubSourceRef.derivedPolicy(
        'xdrip_to_watch_connection_policy',
      ),
      metrics: utils.connectionMetrics(
        source: source,
        target: target,
        delay: delay,
        confidence: confidence,
        policyId: 'xdrip_to_watch_connection_policy',
        sourceLabel: 'xDrip+',
        targetLabel: 'Watch',
      ),
      evidence: utils.evidence(source, target),
      userSummary: state == StatusHubState.fresh
          ? 'Watch display evidence is visible through the xDrip+ path.'
          : 'Watch display depends on xDrip+ Web Service and display bridge evidence.',
      nextCheck:
          'Enable xDrip+ Web Service for watch display, then confirm watch bridge evidence.',
      traceChain: source.traceChain.merge(target.traceChain),
    );
  }

  StatusHubState _state(StatusHubFactBundle facts) {
    if (!facts.watch.bridgePackageObserved) return StatusHubState.notChecked;
    if (!facts.watch.webServiceReachable) return StatusHubState.limited;
    if (!facts.watch.entriesObserved) return StatusHubState.delayed;
    if (facts.watch.displayObserved) return StatusHubState.fresh;
    return StatusHubState.limited;
  }
}
