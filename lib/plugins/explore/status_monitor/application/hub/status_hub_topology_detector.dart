import '../../domain/hub/status_hub_enums.dart';
import '../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../domain/hub/status_hub_models.dart';

class StatusHubTopologyDetector {
  const StatusHubTopologyDetector();

  StatusHubTopology detect(
    StatusHubFactBundle facts,
    List<StatusHubNode> nodes,
    List<StatusHubConnection> connections,
  ) {
    final observedPaths = <String>[];
    if (_pathObserved(connections, StatusHubConnectionId.cgmToXdrip)) {
      observedPaths.add('CGM -> xDrip+');
    }
    if (_pathObserved(connections, StatusHubConnectionId.jugglucoToXdrip)) {
      observedPaths.add('Juggluco -> xDrip+');
    }
    if (_pathObserved(connections, StatusHubConnectionId.xdripToNightscout)) {
      observedPaths.add('xDrip+ -> Nightscout');
    }
    if (_pathObserved(connections, StatusHubConnectionId.xdripToAaps)) {
      observedPaths.add('xDrip+ -> AAPS');
    }

    if (facts.juggluco.xdripCompatiblePathObserved &&
        _pathObserved(connections, StatusHubConnectionId.jugglucoToXdrip)) {
      return StatusHubTopology(
        kind: StatusHubTopologyKind.jugglucoToXdrip,
        label: 'Juggluco primary path',
        observedPaths: observedPaths,
        autoDetected: observedPaths.isNotEmpty,
      );
    }
    if (_pathObserved(connections, StatusHubConnectionId.xdripToAaps)) {
      return StatusHubTopology(
        kind: StatusHubTopologyKind.xdripToAaps,
        label: 'xDrip+ to AAPS path',
        observedPaths: observedPaths,
        autoDetected: true,
      );
    }
    if (_pathObserved(connections, StatusHubConnectionId.xdripToNightscout)) {
      return StatusHubTopology(
        kind: StatusHubTopologyKind.xdripToNightscout,
        label: 'xDrip+ cloud upload path',
        observedPaths: observedPaths,
        autoDetected: true,
      );
    }
    if (_isObserved(nodes, StatusHubNodeId.xdrip)) {
      return StatusHubTopology(
        kind: StatusHubTopologyKind.xdripCollector,
        label: 'xDrip+ collector path',
        observedPaths: observedPaths,
        autoDetected: true,
      );
    }
    if (_isObserved(nodes, StatusHubNodeId.nightscout)) {
      return StatusHubTopology(
        kind: StatusHubTopologyKind.nightscoutOnly,
        label: 'Nightscout-only evidence',
        observedPaths: observedPaths,
        autoDetected: true,
      );
    }
    return const StatusHubTopology(
      kind: StatusHubTopologyKind.unknown,
      label: 'Setup evidence required',
      observedPaths: [],
      autoDetected: false,
    );
  }

  bool _isObserved(List<StatusHubNode> nodes, StatusHubNodeId id) {
    final node = nodes.firstWhere((node) => node.id == id);
    return node.state == StatusHubState.fresh ||
        node.state == StatusHubState.delayed ||
        node.state == StatusHubState.stale ||
        node.state == StatusHubState.limited;
  }

  bool _pathObserved(
    List<StatusHubConnection> connections,
    StatusHubConnectionId id,
  ) {
    final connection = connections.firstWhere((item) => item.id == id);
    return connection.state == StatusHubState.fresh ||
        connection.state == StatusHubState.delayed ||
        connection.state == StatusHubState.limited ||
        connection.state == StatusHubState.stale;
  }
}
