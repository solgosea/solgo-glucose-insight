import 'status_probe_result.dart';
import 'status_probe_source_ref.dart';
import 'status_probe_state.dart';
import 'status_probe_suite_definition.dart';

class StatusProbeSuiteResult {
  final StatusProbeSuiteDefinition definition;
  final StatusProbeState state;
  final String summary;
  final DateTime observedAt;
  final DateTime? latestUsefulEvidenceAt;
  final double confidence;
  final List<StatusProbeResult> results;
  final List<StatusProbeSourceRef> sourceRefs;

  const StatusProbeSuiteResult({
    required this.definition,
    required this.state,
    required this.summary,
    required this.observedAt,
    this.latestUsefulEvidenceAt,
    required this.confidence,
    required this.results,
    this.sourceRefs = const [],
  });

  String get suiteId => definition.id;
}
