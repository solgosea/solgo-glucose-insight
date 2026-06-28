import '../../../domain/hub/facts/status_hub_component_facts.dart';
import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/path/status_hub_path_models.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../policies/status_hub_connection_policy_utils.dart';

class StatusHubPathEvidenceBuilder {
  final StatusHubConnectionPolicyUtils utils;

  const StatusHubPathEvidenceBuilder({
    this.utils = const StatusHubConnectionPolicyUtils(),
  });

  List<StatusHubPathEvidence> build(StatusHubFactBundle facts) {
    return [
      _path(
        id: StatusHubConnectionId.cgmToXdrip,
        source: facts.cgm.component,
        target: facts.xdrip.component,
        sourceNode: StatusHubNodeId.cgmSensor,
        targetNode: StatusHubNodeId.xdrip,
        aligned: _freshish(facts.cgm.component.state) &&
            _freshish(facts.xdrip.component.state),
      ),
      _path(
        id: StatusHubConnectionId.jugglucoToXdrip,
        source: facts.juggluco.component,
        target: facts.xdrip.component,
        sourceNode: StatusHubNodeId.juggluco,
        targetNode: StatusHubNodeId.xdrip,
        aligned: facts.juggluco.xdripCompatiblePathObserved,
        alignmentAvailable: facts.juggluco.hasXdripCompatiblePathEvidence,
      ),
      _path(
        id: StatusHubConnectionId.xdripToNightscout,
        source: facts.xdrip.component,
        target: facts.nightscout.component,
        sourceNode: StatusHubNodeId.xdrip,
        targetNode: StatusHubNodeId.nightscout,
        aligned: _freshish(facts.xdrip.component.state) &&
            _freshish(facts.nightscout.component.state),
      ),
      _path(
        id: StatusHubConnectionId.xdripToAaps,
        source: facts.xdrip.component,
        target: facts.aaps.component,
        sourceNode: StatusHubNodeId.xdrip,
        targetNode: StatusHubNodeId.aaps,
        aligned: facts.aaps.xdripBgSourceObserved,
        alignmentAvailable: facts.aaps.hasXdripBgSourceEvidence,
      ),
      _path(
        id: StatusHubConnectionId.xdripToWatch,
        source: facts.xdrip.component,
        target: facts.xdrip.component,
        sourceNode: StatusHubNodeId.xdrip,
        targetNode: StatusHubNodeId.watch,
        aligned: false,
      ),
    ];
  }

  StatusHubPathEvidence _path({
    required StatusHubConnectionId id,
    required StatusHubComponentFacts source,
    required StatusHubComponentFacts target,
    required StatusHubNodeId sourceNode,
    required StatusHubNodeId targetNode,
    required bool aligned,
    bool alignmentAvailable = true,
  }) {
    return StatusHubPathEvidence(
      pathId: id,
      sourceNode: sourceNode,
      targetNode: targetNode,
      sourceAge: source.age,
      targetAge: target.age,
      delayVsSource: utils.delay(source, target),
      sourceAvailable: source.state != StatusHubState.unavailable,
      targetAvailable: target.state != StatusHubState.unavailable,
      alignmentObserved: aligned,
      alignmentEvidenceAvailable: alignmentAvailable,
      evidenceRefs: utils.evidence(source, target),
    );
  }

  bool _freshish(StatusHubState state) {
    return state == StatusHubState.fresh || state == StatusHubState.delayed;
  }
}
