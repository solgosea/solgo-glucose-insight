import '../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../domain/hub/status_hub_enums.dart';
import '../../domain/hub/status_hub_models.dart';
import '../../domain/status_level.dart';

class StatusHubFocusResolver {
  const StatusHubFocusResolver();

  StatusHubFocus resolve({
    required StatusHubFactBundle facts,
    required List<StatusHubNode> nodes,
    required List<StatusHubConnection> connections,
  }) {
    final prioritized = connections
        .where((connection) => connection.showInDetails)
        .where((connection) => connection.diagnosisPriority > 0)
        .toList()
      ..sort((a, b) {
        final priority = b.diagnosisPriority.compareTo(a.diagnosisPriority);
        if (priority != 0) return priority;
        return _rank(b.state).compareTo(_rank(a.state));
      });

    if (prioritized.isNotEmpty) {
      final target = prioritized.first;
      return StatusHubFocus(
        connectionId: target.id,
        reason: _focusReasonFor(target),
        severity: _levelFor(target.state),
        headline: target.nextCheck,
        explanation: target.userSummary,
        badgeLabel: target.chipLabel,
        suggestedChecks: [target.nextCheck],
      );
    }

    return const StatusHubFocus(
      reason: StatusHubFocusReason.allClear,
      severity: StatusLevel.healthy,
      headline: 'No urgent hub break found',
      explanation:
          'Available path evidence does not show a clear break around the xDrip+ hub.',
      suggestedChecks: [
        'Keep the core apps running and review alerts if a path changes state.',
      ],
    );
  }

  StatusHubFocusReason _focusReasonFor(StatusHubConnection connection) {
    return switch (connection.diagnosisReason) {
      StatusHubPathDiagnosisReason.sourceStale ||
      StatusHubPathDiagnosisReason.hubDelayed =>
        StatusHubFocusReason.upstreamStale,
      StatusHubPathDiagnosisReason.compatiblePathMissing =>
        StatusHubFocusReason.handoffDelayed,
      StatusHubPathDiagnosisReason.uploadDelayed ||
      StatusHubPathDiagnosisReason.cloudUnavailable ||
      StatusHubPathDiagnosisReason.localObservationStale =>
        StatusHubFocusReason.targetDelayedVsSource,
      StatusHubPathDiagnosisReason.bgSourceMissing =>
        StatusHubFocusReason.setupRequired,
      StatusHubPathDiagnosisReason.loopContextLimited =>
        StatusHubFocusReason.downstreamLimited,
      _ => StatusHubFocusReason.evidenceLimited,
    };
  }

  int _rank(StatusHubState state) {
    return switch (state) {
      StatusHubState.stale || StatusHubState.unavailable => 3,
      StatusHubState.delayed => 2,
      StatusHubState.limited || StatusHubState.unknown => 1,
      _ => 0,
    };
  }

  StatusLevel _levelFor(StatusHubState state) {
    return switch (state) {
      StatusHubState.stale || StatusHubState.unavailable => StatusLevel.issue,
      StatusHubState.delayed || StatusHubState.limited => StatusLevel.watch,
      StatusHubState.fresh => StatusLevel.healthy,
      _ => StatusLevel.unknown,
    };
  }
}
