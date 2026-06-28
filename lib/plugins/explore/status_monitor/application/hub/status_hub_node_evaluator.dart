import '../../domain/hub/facts/status_hub_component_facts.dart';
import '../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../domain/hub/status_hub_enums.dart';
import '../../domain/hub/status_hub_models.dart';

class StatusHubNodeEvaluator {
  const StatusHubNodeEvaluator();

  List<StatusHubNode> evaluate(StatusHubFactBundle facts) {
    return [
      _node(facts.cgm.component),
      _node(facts.juggluco.component),
      _node(facts.xdrip.component),
      _node(facts.nightscout.component),
      _node(facts.aaps.component),
      _node(facts.watch.component),
      const StatusHubNode(
        id: StatusHubNodeId.solgoObserver,
        label: 'Solgo Insight',
        role: StatusHubNodeRole.observer,
        state: StatusHubState.fresh,
        confidence: 1,
        evidence: [],
        source: StatusHubSourceRef.staticCopy(),
      ),
    ];
  }

  StatusHubNode _node(StatusHubComponentFacts facts) {
    return StatusHubNode(
      id: facts.nodeId,
      label: facts.label,
      role: facts.role,
      state: facts.state,
      latestObservedAt: facts.latestObservedAt,
      age: facts.age,
      confidence: facts.confidence,
      evidence: facts.evidence,
      detailRoute: facts.detailRoute,
      source: _source(facts),
      traceChain: facts.traceChain,
    );
  }

  StatusHubSourceRef _source(StatusHubComponentFacts facts) {
    for (final evidence in facts.evidence) {
      if (evidence.source.available) return evidence.source;
    }
    return StatusHubSourceRef.probeEvidence(
      probeId: 'suite.${facts.kind.queryValue}',
      available: facts.state != StatusHubState.unavailable,
    );
  }
}
