import '../../domain/hub/status_hub_enums.dart';
import '../../domain/hub/status_hub_models.dart';

class StatusHubShareSummaryBuilder {
  const StatusHubShareSummaryBuilder();

  String build(StatusHubReportDraft draft) {
    final focus = draft.focus;
    final primary = draft.connections
        .where((connection) => connection.isPrimaryPath)
        .map((connection) {
      return '- ${_connectionLabel(connection)}: ${_stateLabel(connection)}';
    }).join('\n');
    final checks = focus.suggestedChecks.map((check) => '- $check').join('\n');
    return [
      'xDrip+ Hub check',
      'Observed path: ${draft.topology.label}',
      'Priority: ${focus.headline}',
      'Evidence: ${draft.evidenceQuality.label} '
          '(${draft.evidenceQuality.availableEvidenceCount}/${draft.evidenceQuality.expectedEvidenceCount})',
      if (primary.isNotEmpty) 'Primary paths:\n$primary',
      if (checks.isNotEmpty) 'Suggested checks:\n$checks',
      'Privacy note: no URL, token, or subject identifier is included.',
    ].join('\n');
  }

  String _connectionLabel(StatusHubConnection connection) {
    return switch (connection.id) {
      StatusHubConnectionId.cgmToXdrip => 'CGM -> xDrip+',
      StatusHubConnectionId.jugglucoToXdrip => 'Juggluco -> xDrip+',
      StatusHubConnectionId.xdripToNightscout => 'xDrip+ -> Nightscout',
      StatusHubConnectionId.xdripToAaps => 'xDrip+ -> AAPS',
      StatusHubConnectionId.xdripToWatch => 'xDrip+ -> Watch',
    };
  }

  String _stateLabel(StatusHubConnection connection) {
    return connection.state.name;
  }
}

class StatusHubReportDraft {
  final StatusHubTopology topology;
  final List<StatusHubConnection> connections;
  final StatusHubFocus focus;
  final StatusHubEvidenceQuality evidenceQuality;

  const StatusHubReportDraft({
    required this.topology,
    required this.connections,
    required this.focus,
    required this.evidenceQuality,
  });
}
