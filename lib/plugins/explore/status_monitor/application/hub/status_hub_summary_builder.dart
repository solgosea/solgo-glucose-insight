import '../../domain/hub/status_hub_enums.dart';
import '../../domain/hub/status_hub_models.dart';

class StatusHubSummaryBuilder {
  const StatusHubSummaryBuilder();

  StatusHubSummary build({
    required StatusHubTopology topology,
    required StatusHubFocus focus,
    required List<StatusHubConnection> connections,
  }) {
    final attentionCount = connections
        .where((connection) => connection.showInDetails)
        .where((connection) => connection.state.needsAttention)
        .length;
    final primaryCount = connections
        .where((connection) => connection.showInDetails)
        .where((connection) => connection.isPrimaryPath)
        .length;
    final state = _stateFor(focus, connections);
    return StatusHubSummary(
      state: state,
      headline: _headlineFor(state, focus),
      body: focus.explanation,
      meta: '$primaryCount primary paths / $attentionCount attention items',
    );
  }

  String _headlineFor(StatusHubState state, StatusHubFocus focus) {
    if (focus.reason == StatusHubFocusReason.allClear) {
      return 'xDrip+ hub path has no urgent break in available evidence.';
    }
    return switch (state) {
      StatusHubState.fresh => 'xDrip+ has fresh local data. ${focus.headline}.',
      StatusHubState.delayed =>
        'xDrip+ hub has a delayed downstream or handoff path.',
      StatusHubState.stale ||
      StatusHubState.unavailable =>
        'xDrip+ hub needs attention before downstream checks.',
      StatusHubState.limited =>
        'xDrip+ hub evidence is limited. ${focus.headline}.',
      _ => 'xDrip+ hub needs more observable evidence.',
    };
  }

  StatusHubState _stateFor(
    StatusHubFocus focus,
    List<StatusHubConnection> connections,
  ) {
    final visibleConnections = connections
        .where((connection) => connection.showInDetails)
        .toList(growable: false);
    if (focus.reason == StatusHubFocusReason.allClear) {
      return StatusHubState.fresh;
    }
    if (visibleConnections.any((connection) {
      return connection.state == StatusHubState.stale ||
          connection.state == StatusHubState.unavailable;
    })) {
      return StatusHubState.stale;
    }
    if (visibleConnections.any((connection) {
      return connection.state == StatusHubState.delayed ||
          connection.state == StatusHubState.limited;
    })) {
      return StatusHubState.delayed;
    }
    return StatusHubState.unknown;
  }
}
